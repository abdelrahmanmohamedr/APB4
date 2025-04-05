vlib work
vlog *.v *.sv +cover -covercells
vsim -voptargs=+acc work.apb_top -classdebug -uvmcontrol=all -cover
add wave /apb_top/apbint/*
coverage save apb_top.ucdb -onexit
run -all