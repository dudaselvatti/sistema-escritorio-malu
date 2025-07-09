<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Recuperação de Senha - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 mt-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4 text-center">
                        <i class="bi bi-shield-lock-fill text-primary" style="font-size: 3rem;"></i>
                        <h3 class="card-title mt-3">Recuperação de Senha</h3>
                        <p class="text-muted">
                            Para sua segurança, a redefinição de senha é feita através de um processo manual.
                        </p>
                        <div class="alert alert-info mt-4">
                            Por favor, entre em contato com a administração do escritório para solicitar uma nova senha.
                            <br>
                            <strong>E-mail:</strong> malu@escritorio.com
                        </div>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary mt-3">
                            <i class="bi bi-arrow-left me-1"></i> Voltar para o Login
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
