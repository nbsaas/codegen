package ${base}.api.apis;


import ${base}.api.domain.list.${entity.simpleName}List;
import ${base}.api.domain.page.${entity.simpleName}Page;
import ${base}.api.domain.request.*;
import ${base}.api.domain.response.${entity.simpleName}Response;

public interface ${entity.simpleName}Api {

    /**
     * 创建
     *
     * @param request
     * @return
     */
    ${entity.simpleName}Response create(${entity.simpleName}DataRequest request);

    /**
     * 更新
     *
     * @param request
     * @return
     */
    ${entity.simpleName}Response update(${entity.simpleName}DataRequest request);

    /**
     * 删除
     * @param request
     * @return
     */
    ${entity.simpleName}Response delete(${entity.simpleName}DataRequest request);


    /**
    * 详情
    *
    * @param request
    * @return
    */
     ${entity.simpleName}Response view(${entity.simpleName}DataRequest request);


    /**
     * 集合功能
     * @param request
     * @return
     */
    ${entity.simpleName}List list(${entity.simpleName}SearchRequest request);

    /**
     * 搜索功能
     *
     * @param request
     * @return
     */
    ${entity.simpleName}Page search(${entity.simpleName}SearchRequest request);

}