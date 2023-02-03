---------------------------------------------------------------------
-------------
-- Company: ENGS 31, 18X
-- Engineer: Afia Semin
--
-- Create Date: 08/11/2018 07:54:21 PM
-- Design Name:
-- Module Name: pmod_da2 - behavior
-- Project Name: VoiceRecorder

-- Target Devices: Artix 7 - Basys 3
-- Tool Versions:
-- Description: Driver for the Diligent Pmod DA2 (Texas Instruments DAC121S101).
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
---------------------------------------------------------------------
-------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pmod_da2 is
    
    port(
        da_data: in std_logic_vector (11 downto 0);
        tick_sample: in std_logic;
        sclk: in std_logic;
        spi_data: out std_logic;
        spi_sclk: out std_logic;
        spi_cs: out std_logic
        );
        
end pmod_da2;

architecture behavior of pmod_da2 is

    signal n_shifts: unsigned(3 downto 0):="1111";
    signal shift_en: std_logic;
    signal par_data_reg: std_logic_vector( 15 downto 0) := (others =>'0');
    signal TC: std_logic;
    signal iCS: std_logic;
    
    type state is (waits, load, shift);
    signal curr_state, next_state: state;
    
begin
 
    spi_sclk <= sclk;
    spi_cs <= iCS;
    
    shift_count: process(sclk, n_shifts, iCS) begin
        
        if rising_edge(sclk) then
        
            if (n_shifts > 0) and (iCS = '0') then
                n_shifts <= n_shifts - 1;
            elsif n_shifts = "0000" then
                n_shifts <= "1111";
            end if;
            
        end if;
        
        if n_shifts = "0000" then
            TC <= '1';
        else
            TC <= '0';
        end if;
        
    end process shift_count;
        
    input_reg: process(sclk, tick_sample) begin
    
        if rising_edge(sclk) then
        
            if tick_sample = '1' then
                par_data_reg <= std_logic_vector(resize(unsigned(da_data), 16));
            elsif shift_en <= '1' then
                spi_data <= par_data_reg(15);
                par_data_reg <= par_data_reg(14 downto 0) & "0";
            end if;
            
        end if;
        
    end process input_reg;
    
    state_update: process(sclk) begin
    
        if rising_edge(sclk) then
        
            curr_state <= next_state;
            
        end if;
        
    end process state_update;
    
    controller: process(curr_state, tick_sample, TC) begin
    
        iCS <= '1';
        shift_en <= '0';
        next_state <= curr_state;
        
        case curr_state is
        
            when waits =>
                iCS <= '1';
                if tick_sample = '1' then
                next_state <= load;
                end if;
                
            when load =>
                next_state <= shift;
                
            when shift =>
                iCS <= '0';
                shift_en <= '1';
                if TC = '1' then
                    next_state <= waits;
                end if;
                
        end case;
        
    end process controller;

end behavior;
