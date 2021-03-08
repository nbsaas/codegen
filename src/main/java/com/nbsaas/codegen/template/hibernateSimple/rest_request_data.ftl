package ${base}.api.domain.request;


import com.haoxuer.discover.user.api.domain.request.BaseRequest;
import lombok.Data;
<#if enumList??>
<#list enumList as item>
import ${item.className};
</#list>
</#if>
<#if haveBigDecimal>
import java.math.BigDecimal;
</#if>
<#if haveDate>
import java.util.Date;
</#if>

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}DataRequest extends BaseRequest {

    private ${id.simpleName} id;

    <#if requests??>
    <#list requests as item>
     private ${item.type} ${item.id};

    </#list>
    </#if>

}