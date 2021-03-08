package ${base}.api.domain.list;


import ${base}.api.domain.simple.${entity.simpleName}Simple;
import com.haoxuer.discover.rest.base.ResponseList;
import lombok.Data;

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}List  extends ResponseList<${entity.simpleName}Simple> {

}