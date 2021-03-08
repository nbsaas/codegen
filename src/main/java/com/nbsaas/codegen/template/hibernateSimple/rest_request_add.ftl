package ${base}.api.domain.request;


import com.haoxuer.discover.user.api.domain.request.BaseRequest;
import lombok.Data;

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}CreateRequest extends BaseRequest {


    <#if requests??>
    <#list requests as item>
     private ${item.type} ${item.id};

    </#list>
    </#if>

}