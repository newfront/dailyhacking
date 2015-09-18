package com.deppstand.utils;


public class CommonUtils {
    private static volatile int count = 0;

    private CommonUtils(){
        // static class has no constructor
        throw new AssertionError();
    }

    public static int getNextCount() {
        return count++;
    }

}
