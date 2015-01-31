LIBRARY IEEE;
LIBRARY ALTERA_MF;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;

ENTITY SCOMP IS
  PORT(
    CLOCK    : IN    STD_LOGIC;
    RESETN   : IN    STD_LOGIC;
    PC_OUT   : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);
    AC_OUT   : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
    MDR_OUT  : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
    MAR_OUT  : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0);
    IO_WRITE : OUT   STD_LOGIC;
    IO_CYCLE : OUT   STD_LOGIC;
    IO_ADDR  : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0);
    IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END SCOMP;


ARCHITECTURE a OF SCOMP IS
  TYPE STATE_TYPE IS (
    RESET_PC,
    FETCH,
    DECODE,
    EX_LOAD,
    EX_STORE,
    EX_STORE2,
    EX_ADD,
    EX_JUMP,
    EX_AND
  );

  SIGNAL STATE    : STATE_TYPE;
  SIGNAL AC       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IR       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL MDR      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL PC       : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL MEM_ADDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL MW       : STD_LOGIC;


  BEGIN
    -- Use altsyncram component for unified program and data memory
    MEMORY : altsyncram
    GENERIC MAP (
    intended_device_family => "Cyclone",
    width_a          => 16,
    widthad_a        => 10,
    numwords_a       => 1024,
    operation_mode   => "SINGLE_PORT",
    outdata_reg_a    => "UNREGISTERED",
    indata_aclr_a    => "NONE",
    wrcontrol_aclr_a => "NONE",
    address_aclr_a   => "NONE",
    outdata_aclr_a   => "NONE",
    init_file        => "example.mif",
    lpm_hint         => "ENABLE_RUNTIME_MOD=NO",
    lpm_type         => "altsyncram"
    )
    PORT MAP (
    wren_a    => MW,
    clock0    => NOT(CLOCK),
    address_a => MEM_ADDR,
    data_a    => AC,
    q_a       => MDR
    );

    PC_OUT   <= PC;
    AC_OUT   <= AC;
    MDR_OUT  <= MDR;
    MAR_OUT  <= MEM_ADDR;
    IO_WRITE <= '0';
    IO_CYCLE <= '0';
    IO_ADDR  <= IR(7 DOWNTO 0);

    WITH STATE SELECT
      MEM_ADDR <= PC WHEN FETCH,
                 IR(9 DOWNTO 0) WHEN OTHERS;


    PROCESS (CLOCK, RESETN)
      BEGIN
        IF (RESETN = '0') THEN          -- Active low, asynchronous reset
          STATE <= RESET_PC;
        ELSIF (RISING_EDGE(CLOCK)) THEN
          CASE STATE IS
            WHEN RESET_PC =>
              MW        <= '0';          -- Clear memory write flag
              PC        <= "0000000000"; -- Reset PC to the beginning of memory, address 0x000
              AC        <= x"0000";      -- Clear AC register
              STATE     <= FETCH;

            WHEN FETCH =>
              MW    <= '0';             -- Clear memory write flag
              IR    <= MDR;             -- Latch instruction into the IR
              PC    <= PC + 1;          -- Increment PC to next instruction address
              STATE <= DECODE;

            WHEN DECODE =>
              CASE IR(15 downto 10) IS
                WHEN "000000" =>       -- No Operation (NOP)
                  STATE <= FETCH;
                WHEN "000001" =>       -- LOAD
                  STATE <= EX_LOAD;
                WHEN "000010" =>       -- STORE
                  STATE <= EX_STORE;
                WHEN "000011" =>       -- ADD
                  STATE <= EX_ADD;
                WHEN "000101" =>       -- JUMP
                  STATE <= EX_JUMP;
                WHEN "001001" =>       -- AND
                  STATE <= EX_AND;

                WHEN OTHERS =>
                  STATE <= FETCH;      -- Invalid opcodes default to NOP
              END CASE;

            WHEN EX_LOAD =>
              AC    <= MDR;            -- Latch data from MDR (memory contents) to AC
              STATE <= FETCH;

            WHEN EX_STORE =>
              MW    <= '1';            -- Raise MW to write AC to MEM
              STATE <= EX_STORE2;

            WHEN EX_STORE2 =>
              MW    <= '0';            -- Drop MW to end write cycle
              STATE <= FETCH;

            WHEN EX_ADD =>
              AC    <= AC + MDR;
              STATE <= FETCH;

            WHEN EX_JUMP =>
              PC    <= IR(9 DOWNTO 0);
              STATE <= FETCH;
              
            WHEN EX_AND =>
              AC    <= AC AND MDR;
              STATE <= FETCH;

            WHEN OTHERS =>
              STATE <= FETCH;          -- If an invalid state is reached, return to FETCH
          END CASE;
        END IF;
      END PROCESS;
  END a;
