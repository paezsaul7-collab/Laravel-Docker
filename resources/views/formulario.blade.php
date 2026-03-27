<!DOCTYPE html>
<html>
<head>
    <title>Formulario</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            text-align: center;
        }

        .contenedor {
            width: 300px;
            margin: 100px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.2);
        }

        input {
            width: 90%;
            padding: 8px;
            margin-top: 5px;
        }

        button {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            width: 100%;
            border-radius: 5px;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <div class="contenedor">
        <h1>Formulario de usuario</h1>

        <form method="POST" action="/procesar">
            @csrf

            <label>Nombre:</label><br>
            <input type="text" name="nombre">

            <br><br>

            <label>Edad:</label><br>
            <input type="number" name="edad">

            <br><br>

            <button type="submit">Enviar</button>
        </form>
    </div>

</body>
</html>