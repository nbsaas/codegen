package ${base}.api.domain.request;


import lombok.Data;

/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Data
public class ${entity.simpleName}UpdateRequest extends ${entity.simpleName}CreateRequest {

    private ${id.simpleName} id;

}