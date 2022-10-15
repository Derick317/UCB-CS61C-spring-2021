# My Note of Labs

## Lab 02

### Bugs: Left shifts (`«`) will add 0 on the right. 

When implementing `set_bit`, I want to get 0b11$\cdots$1011$\cdots$11, whose nth bit is 0. My original implementation is

```c
unsigned helper = 1;
*x &= ~helper << n // I thought ~helper<<n is 11...101...1
```

However, since `~helper` is 0b111$\cdots$110, `~helper << n` is 0b11$\cdots$100$\cdots$0. That is, `~` and `<<` is incommutable. The correct answer is

```c
unsigned helper = 1;
*x &= ~(helper << n) 
```

### Bugs: An array whose $n$-th value is accessible has at least size ($n+1$).

`void vector_set(vector_t *v, size_t loc, int value)` is a function to set `value` in the `loc`-th place in a vector `*v`. If the size of vector `*v` is less than `loc`, we need to reallocate memory. My original implementation is

```c
void vector_set(vector_t *v, size_t loc, int value) {
    if(loc >= v->size)
    {
        v->data = (int *)realloc(v->data, sizeof(int) *loc);
        if(NULL == v->data)
            allocation_failed();
        for(int i = v->size; i < loc; i++)
            v->data[i] = 0;
        v->size = loc;
    }
    v->data[loc] = value;
}
```

`v->data[loc]` , however, is invalid when `v->data` is of size `loc`. Therefore, the correct answer is (two changes):

```c
void vector_set(vector_t *v, size_t loc, int value) {
    if(loc >= v->size)
    {
        v->data = (int *)realloc(v->data, sizeof(int) * (loc + 1));
        if(NULL == v->data)
            allocation_failed();
        for(int i = v->size; i < loc; i++)
            v->data[i] = 0;
        v->size = loc + 1;
    }
    v->data[loc] = value;
}
```

