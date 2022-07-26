ENTRY(booting);
SECTIONS
{
    . = 0x7C00;
    .text : AT(0x7C00)
    {
        *(.text);
    }
    .rodata : 
    {
		*(.rodata)
		*(.rodata*)
	}
	.data : 
	{
		*(.data)
		*(.data*)
	}
	.bss : 
	{
		*(.bss)
		*(.bss*)
	}
	
    .stack :
	{
		
	}	
    .sig : AT(0x7DFE)
    {
        SHORT(0xaa55);
    }
}
