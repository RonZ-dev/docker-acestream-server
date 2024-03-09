from flask import Flask, request, render_template_string
import subprocess

app = Flask(__name__)

HTML = """
<html>
<head>
    <title>ACE Streams</title>
</head>
    <body>
        <form action="/" method="post">
            <input type="text" name="variable_stream" />
            <input type="submit" />
        </form>
        <p>{{ output | safe }}</p>
    </body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def main():
    output = ''
    if request.method == 'POST':
        variable_stream = request.form['variable_stream']
        # Here you would call your script with the variable_stream
        # For security reasons, we're just simulating it with a print statement
        output = subprocess.check_output(['python', 'playstream.py', '--ace-stream-pid', variable_stream])
        output = output.decode('utf-8').replace('\n', '<br>')
    return render_template_string(HTML, output=output)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
