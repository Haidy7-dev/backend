import { config } from "dotenv";

config();

export const PORT = process.env.PORT || 3000;
export const DB_USER = process.env.DB_USER || root;
export const DB_PASSWORD = process.env.DB_PASSWORD || "";
export const DB_HOST = process.env.BD_HOST || 3306;
export const DB_DATABASE = process.env.DB_DATABASE || "repositorio2";
export const CLAVE__JWT = process.env.CLAVE__JWT;