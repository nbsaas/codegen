package ${dao_p!""};


import  com.haoxuer.discover.data.core.BaseDao;
import  com.haoxuer.discover.data.core.Updater;
import  ${entity.name};

/**
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/
public interface ${entity.simpleName}Dao extends BaseDao<${entity.simpleName},${id.simpleName}>{

	 ${entity.simpleName} findById(${id.simpleName} id);

	 ${entity.simpleName} save(${entity.simpleName} bean);

	 ${entity.simpleName} updateByUpdater(Updater<${entity.simpleName}> updater);

	 ${entity.simpleName} deleteById(${id.simpleName} id);
}