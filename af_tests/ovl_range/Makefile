AF_OVL_HOME ?= ../..
STD_OVL     = $(AF_OVL_HOME)/std_ovl
IVFLAGS     = -g2012 -DOVL_VERILOG -DOVL_ASSERT_ON -I$(STD_OVL)

all: clean pass fail

pass:
	iverilog $(IVFLAGS) -s af_tb_ovl_range_pass $(STD_OVL)/ovl_range.v af_tb_ovl_range_pass.sv -o pass.vvp > pass_comp.log 2>&1
	vvp pass.vvp > pass_run.log 2>&1

fail:
	iverilog $(IVFLAGS) -s af_tb_ovl_range_fail $(STD_OVL)/ovl_range.v af_tb_ovl_range_fail.sv -o fail.vvp > fail_comp.log 2>&1
	vvp fail.vvp > fail_run.log 2>&1

check: all
	@echo "=== pass_comp ===" && cat pass_comp.log
	@echo "=== pass_run ===" && cat pass_run.log
	@echo "=== fail_comp ===" && cat fail_comp.log
	@echo "=== fail_run ===" && cat fail_run.log

clean:
	rm -f *.vvp *.log *.vcd
