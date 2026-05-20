from flask import Flask, request, redirect, render_template_string
import sqlite3

app = Flask(__name__)

DB_PATH = "tasks.db"

# Create DB table if it doesn't exist
def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL
            );
        ''')

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        title = request.form['title']
        with sqlite3.connect(DB_PATH) as conn:
            conn.execute('INSERT INTO tasks (title) VALUES (?)', (title,))
        return redirect('/')

    with sqlite3.connect(DB_PATH) as conn:
        tasks = conn.execute('SELECT * FROM tasks').fetchall()

    return render_template_string('''
        <h1>Task Manager</h1>
        <form method="POST">
            <input name="title" placeholder="Enter a task" required>
            <button type="submit">Add</button>
        </form>
        <ul>
            {% for task in tasks %}
                <li>{{ task[1] }}</li>
            {% endfor %}
        </ul>
    ''', tasks=tasks)

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)
