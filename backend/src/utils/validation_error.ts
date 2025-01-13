import { ValidationError } from "./api_error";

export type IndexSignature = { [key: string]: string };
export type GenericIndexSignature = { [key: string]: unknown };

export function validateString(map: IndexSignature, key: string): string {
  const result = map[key];
  if (result === undefined)
    throw new ValidationError(`Missing required field ${key}`);
  return result;
}

export function validateInt(map: IndexSignature, key: string): number {
  const elem = Number.parseInt(validateString(map, key));
  if (isNaN(elem)) throw new ValidationError(`Field ${key} is not an int`);
  return elem;
}

export function isString(obj: unknown): obj is string {
  return typeof obj === 'string' || obj instanceof String
}

export function isInt(obj: unknown): obj is number {
  return typeof obj === 'number';
}

export function isBoolean(obj: unknown): obj is boolean {
  return typeof obj === 'boolean';
}

export function checkString(obj: GenericIndexSignature, key: string): string {
  const res = obj[key];
  if (!isString(res)) throw new ValidationError(`Field ${key} is not a string`);
  return res;
}

export function checkNonEmptyString(obj:GenericIndexSignature, key: string): string {
    const result=checkString(obj,key);
    if(result.length===0)throw new ValidationError(`Field ${key} must not be empty`);
    return result;
}

export function checkInt(obj: GenericIndexSignature, key: string): number {
  const res = obj[key];
  if (!isInt(res)) throw new ValidationError(`Field ${key} is not an int`);
  return res;
}

export function checkBoolean(obj: GenericIndexSignature, key: string): boolean {
  const res = obj[key];
  if (!isBoolean(res)) throw new ValidationError(`Field ${key} is not a boolean`);
  return res;
}


