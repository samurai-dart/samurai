function fibonacci(num) {
    if (num <= 1) return 1;
    return fibonacci(num - 1) + fibonacci(num - 2);
}

var n = fibonacci(13);
console.log(n);