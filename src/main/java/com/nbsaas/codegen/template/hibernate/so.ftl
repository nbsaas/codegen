package ${so_p};

import java.io.Serializable;
import com.haoxuer.discover.data.page.Filter;
import com.haoxuer.discover.data.page.Search;
import lombok.Data;
<#if haveDate>
import java.util.Date;
</#if>

/**
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/
@Data
public class ${entity.simpleName}So implements Serializable {

    <#if searchs??>
    <#list searchs as item>
    //${item.title}
     @Search(name = "${item.key}",operator = Filter.Operator.${item.operator})
     private ${item.className} ${item.id};

    </#list>
    </#if>


    private String sortField;

    private String sortMethod;

}
