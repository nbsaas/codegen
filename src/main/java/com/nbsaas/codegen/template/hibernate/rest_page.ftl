package ${base}.api.domain.page;


import ${base}.api.domain.simple.${entity.simpleName}Simple;
import com.haoxuer.discover.rest.base.ResponsePage;
import lombok.Data;

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}Page  extends ResponsePage<${entity.simpleName}Simple> {

}