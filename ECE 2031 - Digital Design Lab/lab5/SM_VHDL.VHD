LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.All;

ENTITY SM_VHDL IS  -- Do not modify this entity statement!
  PORT(X       : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       RESETN,
       CLOCK   : IN  STD_LOGIC;
       Z       : OUT STD_LOGIC;
       Q       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)  );
END SM_VHDL;       -- Do not modify this entity statement!


ARCHITECTURE behavior of SM_VHDL IS
  TYPE STATE_TYPE IS (A, B, C);
  SIGNAL state : STATE_TYPE;

  BEGIN
    PROCESS(CLOCK, RESETN)
      BEGIN
        IF RESETN = '0' THEN
          state <= A;
        ELSIF CLOCK'EVENT AND CLOCK = '1' THEN
          CASE state IS
            WHEN A =>
              CASE X IS
                WHEN "00" =>
				  state <= B;
				WHEN "01" =>
				  state <= A;
				WHEN "10" =>
				  state <= C;
				WHEN "11" =>
				  state <= A;
              END CASE;
            WHEN B =>
              CASE X IS
                WHEN "00" =>
				  state <= B;
				WHEN "01" =>
				  state <= B;
				WHEN "10" =>
				  state <= C;
				WHEN "11" =>
				  state <= A;
              END CASE;
            WHEN C =>
              CASE X IS
                WHEN "00" =>
				  state <= B;
				WHEN "01" =>
				  state <= A;
				WHEN "10" =>
				  state <= C;
				WHEN "11" =>
				  state <= C;
              END CASE;
          END CASE;
        END IF;
      END PROCESS;
    Z  <= '1' WHEN state = C ELSE '0';
    Q  <= "00" WHEN state = A ELSE "01" WHEN state = B ELSE "10";

  END behavior;