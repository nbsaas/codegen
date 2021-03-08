package ${base}.api.domain.simple;


import java.io.Serializable;
import lombok.Data;
<#if haveBigDecimal>
import java.math.BigDecimal;
</#if>
<#if haveDate>
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
</#if>
<#if enumList??>
<#list enumList as item>
import ${item.className};
</#list>
</#if>
<#if catalog>
import java.util.List;
</#if>

/**
*
* Created by BigWorld on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/
<#if catalog>

@Data
public class ${entity.simpleName}Simple implements Serializable {
    private Integer id;
    private String value;
    private String label;
    private String name;
    private List<${entity.simpleName}Simple> children;
}
<#else>
@Data
public class ${entity.simpleName}Simple implements Serializable {

    private ${id.simpleName} id;

    <#if simples??>
    <#list simples as item>
     <#if item.type=="Date">
     @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
     </#if>
     private ${item.type} ${item.id};
    </#list>
    </#if>

    <#if enumList??>
    <#list enumList as item>
     private String ${item.field}Name;
    </#list>
    </#if>

}
</#if>