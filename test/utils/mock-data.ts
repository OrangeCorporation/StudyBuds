import { Model } from "sequelize";
import {
  initModels,
} from "../../backend/src/models/init-models";
import sequelize from "../../backend/src/config/database";

export function initData(){
    return initModels(sequelize);
}

async function clearData() {
  const models = initModels(sequelize);
  for (const model of Object.values(models)) {
    // @ts-expect-error lol
    await model.truncate({ cascade: true });
  }
}

async function addData(
  data: Model[],
) {
  for(const model of data){
      await model.save();
  }
}

export async function initDB(data:Model[]) {
  await clearData();
  await addData(data);
}

