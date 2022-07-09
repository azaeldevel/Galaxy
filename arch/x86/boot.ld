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
		*(.rodata*)
	}
	.data : 
	{
		*(.data*)
	}
	.bss : 
	{
		*(.bss*)
	}
	
	
    .sig : AT(0x7DFE)
    {
        SHORT(0xaa55);
    }
}
