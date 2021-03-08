package ${base}.rest.convert;

import ${base}.api.domain.response.${entity.simpleName}Response;
import ${base}.data.entity.${entity.simpleName};
import com.haoxuer.discover.data.rest.core.Conver;
import com.haoxuer.discover.data.utils.BeanDataUtils;

public class ${entity.simpleName}ResponseConvert implements Conver<${entity.simpleName}Response, ${entity.simpleName}> {
    @Override
    public ${entity.simpleName}Response conver(${entity.simpleName} source) {
        ${entity.simpleName}Response result = new ${entity.simpleName}Response();
        BeanDataUtils.copyProperties(source,result);

        <#if responses??>
        <#list responses as item>
        <#if item.fieldType==2>
        if(source.get${item.id?cap_first}()!=null){
           result.set${item.id?cap_first}(source.get${item.id?cap_first}().getId());
        }
        <#elseif item.fieldType==3>
         if(source.get${item.id?cap_first?replace("Name", "")}()!=null){
            result.set${item.id?cap_first}(source.get${item.id?cap_first?replace("Name", "")}().getName());
         }
        <#else>
        </#if>
        </#list>
         </#if>

        <#if enumList??>
        <#list enumList as item>
         result.set${item.field?cap_first}Name(source.get${item.field?cap_first}()+"");
        </#list>
        </#if>

        return result;
    }
}
