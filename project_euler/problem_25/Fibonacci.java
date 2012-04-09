import java.math.BigInteger;

public class Fibonacci 
{
    // start with the last number
    public static BigInteger getFibonacci(int target_length)
    {
        BigInteger l = new BigInteger("1");
        BigInteger c = new BigInteger("1");
        BigInteger tmp;
        int max = target_length;
        int count = 2;
        int length = 1;
        
        while (length < max)
        {
            // fib = last + current
            tmp = l.add(c);
            l = c;
            c = tmp;
            //StdOut.println(c);
            length = c.toString().length();
            count += 1;
        }
        System.out.println(count);
        return c;
    }
    
    public static void main(String[] args)
    {
        // store the current fibonacci numbers
        BigInteger fib = getFibonacci(1000);
        System.out.println(fib);
        System.out.println(fib.toString().length());
    }
}