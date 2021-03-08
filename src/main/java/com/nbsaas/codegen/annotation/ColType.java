package com.nbsaas.codegen.annotation;

public enum ColType {

  col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_none;

  @Override
  public String toString() {
    if (name().equals("col_1")) {
      return "col-xs-1";
    } else if (name().equals("col_2")) {
      return "col-xs-2";
    } else if (name().equals("col_3")) {
      return "col-xs-3";
    } else if (name().equals("col_4")) {
      return "col-xs-4";
    } else if (name().equals("col_5")) {
      return "col-xs-5";
    } else if (name().equals("col_6")) {
      return "col-xs-6";
    } else if (name().equals("col_7")) {
      return "col-xs-7";
    } else if (name().equals("col_8")) {
      return "col-xs-8";
    } else if (name().equals("col_9")) {
      return "col-xs-9";
    } else if (name().equals("col_10")) {
      return "col-xs-10";
    } else if (name().equals("col_11")) {
      return "col-xs-11";
    } else if (name().equals("col_12")) {
      return "col-xs-12";
    } else if (name().equals("col_none")) {
      return "";
    }
    return super.toString();
  }


}
