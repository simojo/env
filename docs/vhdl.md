# Using `VHDL`

* my understanding so far, prone to falsehood

#### Packages to install

* `ghdl`: **must have** for working with moderately simple `vhdl` files without using a GUI/enterprise software.
* `ghdl_ls`: integrable into `nvim_lsp` *(I have yet to get this to work)*

### Simulations

Simulations are useful for doing anything meaningful. If you create a design that corresponds to a truth table, simulations provide an easy mode of verifying your design is correct.  

#### Simulating `.vcd` files

A `.vcd` file is a Value Change Dump file that originates from Verilog. `ghdl` is capable of exporting to the `.vcd` file format for a limited number of outputs. [Check here](https://ghdl-rad.readthedocs.io/en/latest/using/Simulation.html) for more information.  

```sh
$ # after analyzing/elaborating:
$ ghw -r name_of_entity --vcd=vcd_file.vcd
```

* `dwfv` is a lightweight cli that uses `rust-tui` to display `vcd` files, shipping vi-like keybindings.
* [vc.drom.io](https://vc.drom.io/) is a web-based viewer for `vcd` files.
* `gtkwave` can simulate a plethora of filetypes relating to signal analysis, including `vcd` files.

#### Simulating `.ghw` files

A `.ghw` file is a GHdl waveform file, which is currently maintained by the creators of `ghdl`. It supports all signal types in `vhdl`.  

```sh
$ # after analyzing/elaborating:
$ ghw -r name_of_entity --wave=wave_file.ghw
```

* `gtkwave` is the only notable tool I know of that can read `.ghw` files. Obviously a trade-off here between tooling quality and flexibility. Although `gtkwave` has no problem with `X11`, it may be more preferable to use the cli programs mentioned above if one was to work in a headless or legacy environment. [Check here](https://ghdl-rad.readthedocs.io/en/latest/using/Simulation.html) for more information.

#### Idiom-isms

* **entities**: a way to create the structure of a `vhdl` program, namely, the inputs and outputs.
```vhdl
-- file: asdf.vhdl
library ieee;
use ieee.std_logic_1164.all;

entity asdf_entity is
port (
  a: in std_logic;
  b: in std_logic;
  c: out std_logic
);
end asdf_entity;
```
* **architectures** define the behavior of an entity
```vhdl
entity asdf is
...
end asdf;

-- AND gate
architecture asdf_arch of asdf_entity is
begin
  process(a, b) -- sensitivity list
  begin
    c <= a and b;
  end process;
end asdf_arch;
```
* **Sensitivity lists** are put in the `process` section of a program architecture
* **Assignment** is done with the `<=` operator.
```vhdl
...
x <= '0';
...
```

#### Running elaborations/simulations

* to analyze `vhdl` program:
```sh
$ ghdl -a my_file.vhdl
```
* to then run an elaboration (first step of synthesis that generates the logical elements):
```sh
# whatever the entity you want to elaborate is named, in my case 'asdf_entity' as above
$ ghdl -e asdf_entity
```
* In order to effectively simulate the design, you will need to create a *testbench*, which is another `vhdl` file used to inject inputs.
  * It's best practice to inject inputs in ascending order of whichever binary representation you are using.
  * **Example:** This file will increment a 2-bit integer every 1ns that ports `std_logic` variables `a, b` back into `asdf.vhdl`.
  ```
  # directory structure
  ./
  |_ asdf.vhdl
  |_ testbench_asdf.vhdl
  ```
  ```vhdl
  -- file: testbench_asdf.vhdl
  library ieee;
  use ieee.std_logic_1164.all;

  -- place empty entity, because there are no top level dependencies
  entity tb is
  end tb;

  -- create behavior of `tb` entity
  architecture behavior of tb is
  -- create a copy of the other file's entity here to use in the port map
  component asdf_entity is
    port(
      a: in std_logic;
      b: in std_logic;
      c: out std_logic
    );
  end component;
  -- not necessary to use `std_logic_vector`, but for the sake of example...
  signal ab: std_logic_vector (1 downto 0);
  signal c: std_logic;
  begin
    portmap_asdf: asdf port map (a => ab(1), b => ab(0), c => c);
    -- manually putting in all combinations if the easiest method I've discovered so far. Perhaps usign an unsigned integer and incrementing it could be easier.
    -- iterates 2-bit integer in 4ns total
    process
    begin
      ab <= "00";
      wait for 1 ns;
      ab <= "01";
      wait for 1 ns;
      ab <= "10";
      wait for 1 ns;
      ab <= "11";
      wait for 1 ns;
    end process;
  end behavior;
  ```
  ```sh
  $ # generate/view .ghw file for this design:
  $ ghdl -a *.vhdl
  $ ghdl -e tb # must be name of testbench entity title (which is now above asdf.vhdl in heirarchy)
  $ ghdl -r tb --stop-time=4ns --wave=asdf_simulation.ghw
  $ gtkwave asdf_simulation.ghw
  ```
