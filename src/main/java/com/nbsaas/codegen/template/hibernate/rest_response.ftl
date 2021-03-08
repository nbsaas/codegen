package ${base}.api.domain.response;


import com.haoxuer.discover.rest.base.ResponseObject;
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

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}Response extends ResponseObject {

    private ${id.simpleName} id;

    <#if responses??>
    <#list responses as item>
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