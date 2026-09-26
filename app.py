import os
import psycopg2
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

DB_CONFIG = {
    "host": os.environ.get("DB_HOST", "localhost"),
    "port": os.environ.get("DB_PORT", "5432"),
    "dbname": os.environ.get("DB_NAME", "tododb"),
    "user": os.environ.get("DB_USER", "todouser"),
    "password": os.environ.get("DB_PASSWORD", "todopass"),
}


def get_conn():
    return psycopg2.connect(**DB_CONFIG)


def init_db():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS todos (
            id SERIAL PRIMARY KEY,
            task TEXT NOT NULL,
            done BOOLEAN DEFAULT FALSE
        )
    """)
    conn.commit()
    cur.close()
    conn.close()


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/api/todos", methods=["GET"])
def get_todos():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id, task, done FROM todos ORDER BY id")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify([{"id": r[0], "task": r[1], "done": r[2]} for r in rows])


@app.route("/api/todos", methods=["POST"])
def add_todo():
    data = request.get_json()
    task = data.get("task", "").strip()
    if not task:
        return jsonify({"error": "task is required"}), 400

    conn = get_conn()
    cur = conn.cursor()
    cur.execute("INSERT INTO todos (task) VALUES (%s) RETURNING id", (task,))
    new_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"id": new_id, "task": task, "done": False}), 201


@app.route("/api/todos/<int:todo_id>", methods=["PUT"])
def update_todo(todo_id):
    data = request.get_json()
    done = data.get("done", False)

    conn = get_conn()
    cur = conn.cursor()
    cur.execute("UPDATE todos SET done = %s WHERE id = %s", (done, todo_id))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"id": todo_id, "done": done})


@app.route("/api/todos/<int:todo_id>", methods=["DELETE"])
def delete_todo(todo_id):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("DELETE FROM todos WHERE id = %s", (todo_id,))
    conn.commit()
    cur.close()
    conn.close()
    return "", 204


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000, debug=True)
