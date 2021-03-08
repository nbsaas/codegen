package com.nbsaas.codegen;

public class OS {
    private OS() {}

    public static boolean isWindows() {
        return System.getProperty("os.name").contains("Windows");
    }

    public static boolean isOSX() {
        return System.getProperty("os.name").contains("Mac");
    }

    public static boolean isLinux() {
        return !System.getProperty("os.name").contains("Windows") && !System.getProperty("os.name").contains("Mac");
    }

    public static void main(String[] args) {
        System.out.println(isWindows());
    }
}
