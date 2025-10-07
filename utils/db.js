import { DB_DATABASE, DB_HOST, DB_USER, DB_PASSWORD } from "./config.js"
import mysql from "mysql2/promise"

export const pool = mysql.createPool({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_DATABASE,
})