package ${base}.api.domain.request;

import com.haoxuer.discover.user.api.domain.request.BasePageRequest;
import com.haoxuer.discover.data.page.Filter;
import com.haoxuer.discover.data.page.Search;
import lombok.Data;
<#if haveDate>
import java.util.Date;
</#if>

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}SearchRequest extends BasePageRequest {

    <#if searchs??>
    <#list searchs as item>
    //${item.title}
     @Search(name = "${item.key}",operator = Filter.Operator.${item.operator})
     private ${item.className} ${item.id};

    </#list>
    </#if>


    <#if catalog>
    private int fetch;

    @Search(name = "levelInfo",operator = Filter.Operator.eq)
    private Integer level;
    </#if>

    private String sortField;


    private String sortMethod;
}