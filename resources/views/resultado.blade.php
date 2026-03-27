<!DOCTYPE html>
<html>
<head>
    <title>Resultado</title>

    <style>
        body {
            font-family: Arial;
            background-color: #f4f6f9;
            text-align: center;
        }

        .resultado {
            margin-top: 100px;
            background: white;
            padding: 20px;
            display: inline-block;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.2);
        }

        a {
            display: block;
            margin-top: 20px;
            text-decoration: none;
            color: #007BFF;
        }
    </style>
</head>
<body>
<h1>{{ $mensaje }}</h1>
<a href="/">Volver</a>
</body>
</html>