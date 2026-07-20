library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sm_add_test is
   port(
      MAX10_CLK1_50 : in  std_logic;
      KEY           : in  std_logic_vector(1 downto 0);
      SW            : in  std_logic_vector(9 downto 0);

      LEDR          : out std_logic_vector(9 downto 0);

      HEX0          : out std_logic_vector(6 downto 0);
      HEX1          : out std_logic_vector(6 downto 0);
      HEX2          : out std_logic_vector(6 downto 0);
      HEX3          : out std_logic_vector(6 downto 0);
      HEX4          : out std_logic_vector(6 downto 0);
      HEX5          : out std_logic_vector(6 downto 0)
   );
end sm_add_test;

architecture arch of sm_add_test is

   signal sum : std_logic_vector(3 downto 0);

   signal oct_a, oct_b, oct_sum : std_logic_vector(3 downto 0);

   signal segA, segB, segSUM : std_logic_vector(7 downto 0);

begin

   ------------------------------------------------------------------
   -- Somador sinal-magnitude
   ------------------------------------------------------------------
   sm_adder_unit : entity work.sign_mag_add
      generic map(N => 4)
      port map(
         a   => SW(3 downto 0),
         b   => SW(7 downto 4),
         sum => sum
      );

   ------------------------------------------------------------------
   -- LEDs
   ------------------------------------------------------------------
   LEDR(3 downto 0) <= SW(3 downto 0);
   LEDR(7 downto 4) <= SW(7 downto 4);
   LEDR(8) <= sum(3);
   LEDR(9) <= '0';

   ------------------------------------------------------------------
   -- Magnitudes
   ------------------------------------------------------------------
   oct_a   <= '0' & SW(2 downto 0);
   oct_b   <= '0' & SW(6 downto 4);
   oct_sum <= '0' & sum(2 downto 0);

   ------------------------------------------------------------------
   -- Conversores para 7 segmentos
   ------------------------------------------------------------------
   dispA : entity work.hex_to_sseg
      port map(
         hex  => oct_a,
         dp   => '1',
         sseg => segA
      );

   dispB : entity work.hex_to_sseg
      port map(
         hex  => oct_b,
         dp   => '1',
         sseg => segB
      );

   dispSUM : entity work.hex_to_sseg
      port map(
         hex  => oct_sum,
         dp   => '1',
         sseg => segSUM
      );

   ------------------------------------------------------------------
   -- Magnitudes
   ------------------------------------------------------------------
   HEX4 <= segA(6 downto 0);
   HEX2 <= segB(6 downto 0);
   HEX0 <= segSUM(6 downto 0);

   ------------------------------------------------------------------
   -- Sinais
   ------------------------------------------------------------------
   HEX5 <= "1111110" when SW(3)='1' else
           "0001100";

   HEX3 <= "1111110" when SW(7)='1' else
           "0001100";

   HEX1 <= "1111110" when sum(3)='1' else
           "0001100";

end arch;