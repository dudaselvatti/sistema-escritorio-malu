<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Acesso Negado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container text-center mt-5">
        <h1 class="display-1">403</h1>
        <h2>Acesso Negado/Proibido</h2>
        <p class="lead">Você não tem permissão para visualizar esta página.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Voltar para a Página Inicial</a>
    </div>
</body>
</html>
