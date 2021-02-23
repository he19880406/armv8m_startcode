
#define REG32(addr) ((volatile unsigned int *)(addr))

#define readl(a) (*REG32(a))
#define writel(v, a) (*REG32(a) = (v))

#define HFSR 0xE000ED2C

void __aeabi_unwind_cpp_pr0()
{
}

void SystemInit(void)
{

}

int main(void)
{
    return 0;
}
