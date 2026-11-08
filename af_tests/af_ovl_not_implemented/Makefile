AF_OVL_HOME ?= ../..
STD_OVL     = $(AF_OVL_HOME)/std_ovl
AF_OVL      = $(AF_OVL_HOME)/af_ovl
BASEFLAGS   = -g2012 -DOVL_VERILOG -I$(STD_OVL) -I$(AF_OVL)
TB          = af_tb_ovl_not_implemented

CHECKERS = arbiter crc fifo hold_value memory_async memory_sync multiport_fifo \
           next_state no_contention reg_loaded req_ack_unique req_requires stack \
           valid_id value value_coverage xproduct_bit_coverage xproduct_value_coverage
SRCS     = $(foreach c,$(CHECKERS),$(STD_OVL)/ovl_$(c).v)

all: clean warn quiet

# OVL_ASSERT_ON: expect 18 OVL_WARNING lines, PASS
warn:
	iverilog $(BASEFLAGS) -DOVL_ASSERT_ON -s $(TB) $(SRCS) $(TB).sv -o warn.vvp > warn_comp.log 2>&1
	vvp warn.vvp > warn_run.log 2>&1

# Neither OVL_ASSERT_ON nor OVL_COVER_ON: expect 0 OVL_WARNING lines, PASS
quiet:
	iverilog $(BASEFLAGS) -s $(TB) $(SRCS) $(TB).sv -o quiet.vvp > quiet_comp.log 2>&1
	vvp quiet.vvp > quiet_run.log 2>&1

check: all
	@echo "=== warn_comp ===" && cat warn_comp.log
	@echo "=== warn_run ===" && cat warn_run.log
	@echo "=== quiet_comp ===" && cat quiet_comp.log
	@echo "=== quiet_run ===" && cat quiet_run.log
	@echo "=== summary (expect warn 18, quiet 0) ==="
	@echo "warn  OVL_WARNING count: `grep -c 'OVL_WARNING' warn_run.log`"
	@echo "quiet OVL_WARNING count: `grep -c 'OVL_WARNING' quiet_run.log`"

clean:
	rm -f *.vvp *.log *.vcd
