ENTRY(loading);
SECTIONS
{
    . = 0x8000;
    .text : AT(0x8000)
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
	
}
