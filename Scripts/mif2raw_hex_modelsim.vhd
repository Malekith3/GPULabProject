library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;
-------------------------------------------------------------------------------
entity mif2raw_hex is
   generic
      (pic_width      : integer := 256;
       pic_height     : integer := 256;
       file_path      : string  := "C:\\source\\VHDL\\GPULabProject\\";
       mif_file_path  : string  := "C:\\source\\VHDL\\GPULabProject\\MEM\\";
       pic_file_name  : string  := "restored_msim.raw";
       rmif_file_name : string  := "r.mem";
       gmif_file_name : string  := "g.mem";
       bmif_file_name : string  := "b.mem";
       color_depth    : integer := 5
       );
end entity mif2raw_hex;
-------------------------------------------------------------------------------
architecture arc_mif2raw_hex of mif2raw_hex is
type byte is
      (
         b000, b001, b002, b003, b004, b005, b006, b007,
         b008, b009, b010, b011, b012, b013, b014, b015,
         b016, b017, b018, b019, b020, b021, b022, b023,
         b024, b025, b026, b027, b028, b029, b030, b031,
         b032, b033, b034, b035, b036, b037, b038, b039,
         b040, b041, b042, b043, b044, b045, b046, b047,
         b048, b049, b050, b051, b052, b053, b054, b055,
         b056, b057, b058, b059, b060, b061, b062, b063,
         b064, b065, b066, b067, b068, b069, b070, b071,
         b072, b073, b074, b075, b076, b077, b078, b079,
         b080, b081, b082, b083, b084, b085, b086, b087,
         b088, b089, b090, b091, b092, b093, b094, b095,
         b096, b097, b098, b099, b100, b101, b102, b103,
         b104, b105, b106, b107, b108, b109, b110, b111,
         b112, b113, b114, b115, b116, b117, b118, b119,
         b120, b121, b122, b123, b124, b125, b126, b127,
         b128, b129, b130, b131, b132, b133, b134, b135,
         b136, b137, b138, b139, b140, b141, b142, b143,
         b144, b145, b146, b147, b148, b149, b150, b151,
         b152, b153, b154, b155, b156, b157, b158, b159,
         b160, b161, b162, b163, b164, b165, b166, b167,
         b168, b169, b170, b171, b172, b173, b174, b175,
         b176, b177, b178, b179, b180, b181, b182, b183,
         b184, b185, b186, b187, b188, b189, b190, b191,
         b192, b193, b194, b195, b196, b197, b198, b199,
         b200, b201, b202, b203, b204, b205, b206, b207,
         b208, b209, b210, b211, b212, b213, b214, b215,
         b216, b217, b218, b219, b220, b221, b222, b223,
         b224, b225, b226, b227, b228, b229, b230, b231,
         b232, b233, b234, b235, b236, b237, b238, b239,
         b240, b241, b242, b243, b244, b245, b246, b247,
         b248, b249, b250, b251, b252, b253, b254, b255
         );
   
    type bit_file is file of byte;
begin
   process is
      type     bit_file is file of byte;
      file pic_dest                                  : bit_file open write_mode is file_path & pic_file_name;
      file mif_r, mif_g, mif_b                       : text;
      variable curr_color                            : byte;
      variable line_r, line_g, line_b                : line;
      variable r, g, b                               : std_logic_vector(color_depth-1 downto 0);
      variable status_r, status_g, status_b          : file_open_status;
      variable rline_rstat, gline_rstat, bline_rstat : boolean;
      variable raddr, baddr, gaddr                   : std_logic_vector(7 downto 0);
      variable rdat, gdat, bdat                      : std_logic_vector(pic_width*color_depth -1 downto 0);
      variable rstr, gstr, bstr                      : string(1 to 2);
      --variable rchar, gchar, bchar                 : character;
   begin
      file_open(status_r, mif_r, mif_file_path & rmif_file_name, read_mode);
      assert (status_r = open_ok)
         report "file creating failure" & time'image(now)
         severity failure;
      assert (status_r /= open_ok)
         report "file rmif is opened"
         severity note;
      file_open(status_g, mif_g, mif_file_path & gmif_file_name, read_mode);
      assert (status_g = open_ok)
         report "file creating failure" & time'image(now)
         severity failure;
      assert (status_g /= open_ok)
         report "file gmif is opened"
         severity note;
      file_open(status_b, mif_b, mif_file_path & bmif_file_name, read_mode);
      assert (status_r = open_ok)
         report "file creating failure" & time'image(now)
         severity failure;
      assert (status_b /= open_ok)
         report "file bmif is opened"
         severity note;
      while (not ENDFILE(mif_r)) loop
         READLINE(mif_r, line_r);
         READLINE(mif_g, line_g);
         READLINE(mif_b, line_b);
         HREAD(line_r, raddr, rline_rstat);
         HREAD(line_g, gaddr, gline_rstat);
         HREAD(line_b, baddr, bline_rstat);
         next when (not rline_rstat);
         READ(line_r, rstr, rline_rstat);
         READ(line_g, gstr, gline_rstat);
         READ(line_b, bstr, bline_rstat);
         READ(line_r, rdat, rline_rstat);
         READ(line_g, gdat, gline_rstat);
         READ(line_b, bdat, bline_rstat);
         l1 : for i in pic_width-1 downto 0 loop
            r := rdat((i*color_depth+color_depth-1) downto i*color_depth);
            g := gdat((i*color_depth+color_depth-1) downto i*color_depth);
            b := bdat((i*color_depth+color_depth-1) downto i*color_depth);
            write(pic_dest, byte'val(conv_integer(r & conv_std_logic_vector(0, 8-color_depth))));
            write(pic_dest, byte'val(conv_integer(g & conv_std_logic_vector(0, 8-color_depth))));
            write(pic_dest, byte'val(conv_integer(b & conv_std_logic_vector(0, 8-color_depth))));
         end loop l1;
      end loop;
      file_close(pic_dest);
      file_close(mif_r);
      file_close(mif_g);
      file_close(mif_b);
      assert (false)
         report "Destination files at " & file_path & pic_file_name & " is created"
         severity note;
      wait;
   end process;
end architecture arc_mif2raw_hex;
