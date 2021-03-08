package ${base}.rest.convert;

import ${base}.api.domain.simple.${entity.simpleName}Simple;
import ${base}.data.entity.${entity.simpleName};
import com.haoxuer.discover.data.rest.core.Conver;
<#if catalog>
import com.haoxuer.discover.config.utils.ConverResourceUtils;
import lombok.Data;


@Data
</#if>
public class ${entity.simpleName}SimpleConvert implements Conver<${entity.simpleName}Simple, ${entity.simpleName}> {

    <#if catalog>
    private int fetch;
    </#if>

    @Override
    public ${entity.simpleName}Simple conver(${entity.simpleName} source) {
        ${entity.simpleName}Simple result = new ${entity.simpleName}Simple();

        <#if catalog>
         result.setId(source.getId());
         result.setLabel(source.getName());
         result.setValue(""+source.getId());
         result.setName(source.getName());
         if (fetch!=0&&source.getChildren()!=null&&source.getChildren().size()>0){
             result.setChildren(ConverResourceUtils.converList(source.getChildren(),this));
         }
        <#else>
            result.setId(source.getId());
            <#if simples??>
            <#list simples as item>
            <#if item.fieldType==2>
            if(source.get${item.id?cap_first}()!=null){
               result.set${item.id?cap_first}(source.get${item.id?cap_first}().getId());
            }
            <#elseif item.fieldType==3>
             if(source.get${item.id?cap_first?replace("Name", "")}()!=null){
                result.set${item.id?cap_first}(source.get${item.id?cap_first?replace("Name", "")}().getName());
             }
            <#else>
             result.set${item.id?cap_first}(source.get${item.id?cap_first}());
            </#if>
            </#list>
             </#if>

            <#if enumList??>
            <#list enumList as item>
             result.set${item.field?cap_first}Name(source.get${item.field?cap_first}()+"");
            </#list>
            </#if>
         </#if>
        return result;
    }
}
