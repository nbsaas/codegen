package com.nbsaas.codegen.fields;

import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Data
public class FormBean implements Serializable{

    private String title;

    private String add;

    private String list;

    private String update;

    private String menu;

    private String searchWidth;

    private String viewWidth;



    private Boolean hasDate=false;

    private Boolean hasImage=false;

    private List<FieldBean> fields=new ArrayList<FieldBean>();


    private List<FieldBean> dates=new ArrayList<FieldBean>();


    private List<FieldBean> grids=new ArrayList<FieldBean>();


    private List<FieldBean> images=new ArrayList<FieldBean>();


}
