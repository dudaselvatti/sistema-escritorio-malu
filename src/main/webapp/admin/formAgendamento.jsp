<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty agendamento ? 'Editar' : 'Novo'} Agendamento - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    
    <style>
        #horarios-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(90px, 1fr));
            gap: 0.5rem;
        }
        .time-slot {
            font-weight: 500;
            transition: all 0.2s ease-in-out;
        }
        .time-slot.btn-primary {
            color: white !important; background-color: #1A3B5D; border-color: #1A3B5D;
            transform: scale(1.05); box-shadow: 0 4px 15px rgba(26, 59, 93, 0.25);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/paineladmin.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container my-4 my-md-5">
    <div class="card form-container-card mx-auto" style="max-width: 800px;">
        <form action="agendamento?action=${not empty agendamento ? 'atualizar' : 'inserir'}" method="POST">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-calendar-plus me-2"></i> 
                    ${not empty agendamento ? 'Editar' : 'Novo'} Agendamento
                </h3>
                 <p class="text-muted mb-0 mt-1">Preencha os dados para criar ou editar um agendamento no sistema.</p>
            </div>

            <div class="card-body p-4">
                
                <c:if test="${isPastAppointment}"><div class="alert alert-warning d-flex align-items-center" role="alert"><i class="bi bi-exclamation-triangle-fill me-2"></i><div><strong>Atenção:</strong> Este é um agendamento passado. Apenas a descrição e o status podem ser alterados.</div></div></c:if>
                <c:if test="${not empty erro}"><div class="alert alert-danger d-flex align-items-center" role="alert"><i class="bi bi-x-octagon-fill me-2"></i><div>${erro}</div></div></c:if>

                <c:if test="${not empty agendamento}"><input type="hidden" name="id" value="${agendamento.idAgendamento}" /></c:if>

                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Passo 1: Envolvidos</legend>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idCliente" class="form-label">Cliente:</label>
                            <select id="idCliente" name="idCliente" class="form-select" required <c:if test="${isPastAppointment}">disabled</c:if>>
                                <option value="">Selecione um cliente...</option>
                                <c:forEach var="cli" items="${listaClientes}"><option value="${cli.idCliente}" ${agendamento.idCliente == cli.idCliente ? 'selected' : ''}>${cli.nome}</option></c:forEach>
                            </select>
                            <c:if test="${isPastAppointment}"><input type="hidden" name="idCliente" value="${agendamento.idCliente}" /></c:if>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="idAdvogado" class="form-label">Advogado:</label>
                            <select id="idAdvogado" name="idAdvogado" class="form-select" required <c:if test="${isPastAppointment}">disabled</c:if>>
                                <option value="">Selecione um advogado...</option>
                                <c:forEach var="adv" items="${listaAdvogados}"><option value="${adv.idAdvogado}" ${agendamento.idAdvogado == adv.idAdvogado ? 'selected' : ''}>${adv.nome}</option></c:forEach>
                            </select>
                            <c:if test="${isPastAppointment}"><input type="hidden" name="idAdvogado" value="${agendamento.idAdvogado}" /></c:if>
                        </div>
                    </div>
                </fieldset>

                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Passo 2: Data e Hora</legend>
                    <div class="mb-3">
                        <label for="data" class="form-label">Data:</label>
                        <input type="date" class="form-control" id="data" name="data" required 
                               value="${agendamento.data}"
                               min="${hoje}" <c:if test="${isPastAppointment}">readonly</c:if> disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Horários Disponíveis:</label>
                        <div id="horarios-container" class="border p-3 rounded bg-light">
                            <p class="text-muted m-0">Por favor, selecione um advogado para habilitar a data.</p>
                        </div>
                        <input type="hidden" id="hora" name="hora" required>
                    </div>
                </fieldset>
                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Passo 3: Detalhes Finais</legend>
                    <div class="mb-3">
                        <label for="descricao" class="form-label">Descrição (opcional):</label>
                        <textarea class="form-control" id="descricao" name="descricao" rows="3"><c:out value="${agendamento.descricao}"/></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status:</label>
                        <select id="status" name="status" class="form-select">
                            <option value="agendado" ${agendamento.status == 'agendado' ? 'selected' : ''}>Agendado</option>
                            <option value="concluído" ${agendamento.status == 'concluído' ? 'selected' : ''}>Concluído</option>
                            <option value="cancelado" ${agendamento.status == 'cancelado' ? 'selected' : ''}>Cancelado</option>
                        </select>
                    </div>
                </fieldset>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="agendamento?action=listar" class="btn btn-outline-secondary me-2"><i class="bi bi-x-lg me-1"></i> Cancelar</a>
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i> Salvar</button>
            </div>
        </form>
    </div>
</div>

<footer class="py-4 bg-dark text-white mt-auto">
    <div class="container text-center"><p class="mb-0">&copy; 2025 Escritório MaLu. Todos os direitos reservados.</p></div>
</footer>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        var advogadoSelect = $('#idAdvogado');
        var dataInput = $('#data');
        var horariosContainer = $('#horarios-container');
        var horaInput = $('#hora');
        
        advogadoSelect.on('change', function() {
            var idAdvogado = $(this).val();
            dataInput.prop('disabled', !idAdvogado).val('');
            horariosContainer.html('<p class="text-muted m-0">Por favor, selecione uma data.</p>');
            horaInput.val('');
        });

       
        dataInput.on('change', function() {
            var data = $(this).val();
            var idAdvogado = advogadoSelect.val(); 

            if (!data || !idAdvogado) return;

            horariosContainer.html('<div class="d-flex justify-content-center align-items-center h-100"><div class="spinner-border text-primary" role="status"></div><span class="ms-2 text-primary">Verificando...</span></div>');
            $.ajax({
                url: '${pageContext.request.contextPath}/disponibilidade',
                type: 'GET',
                data: { data: data, idAdvogado: idAdvogado },
                dataType: 'json',
                success: function(horariosOcupados) {
                    gerarGradeDeHorarios(horariosOcupados, data);
                },
                error: function() {
                    horariosContainer.html('<p class="text-danger m-0">Erro ao carregar horários.</p>');
                }
            });
        });


        function gerarGradeDeHorarios(horariosOcupados, dataSelecionada) {
            horariosContainer.empty();
            horaInput.val('');
            var agora = new Date();
            var hoje = agora.toISOString().split('T')[0];
            var horariosDisponiveis = 0;

            for (var i = 9; i <= 17; i++) {
                if (i === 12) continue;
                for (var j = 0; j < 60; j += 30) {
                    var hora = String(i).padStart(2, '0');
                    var minuto = String(j).padStart(2, '0');
                    var horario = hora + ":" + minuto;
                    var isOcupado = horariosOcupados.includes(horario);
                    var isPassado = false;
                    
                    if (dataSelecionada === hoje) {
                        var horaAtual = agora.getHours();
                        var minutoAtual = agora.getMinutes();
                        if (i < horaAtual || (i === horaAtual && j < minutoAtual)) {
                            isPassado = true;
                        }
                    }

                    if (!isOcupado && !isPassado) horariosDisponiveis++;
                    var btnClass = (isOcupado || isPassado) ? 'btn-secondary disabled' : 'btn-outline-primary';
                    var button = $('<button type="button" class="btn ' + btnClass + ' time-slot" data-time="' + horario + '">' + horario + '</button>');
                    horariosContainer.append(button);
                }
            }
            if (horariosDisponiveis === 0) {
                 horariosContainer.html('<p class="text-warning m-0">Não há horários disponíveis. Por favor, escolha outra data ou advogado.</p>');
            }
        }

        horariosContainer.on('click', '.time-slot:not(.disabled)', function() {
            $('.time-slot').removeClass('btn-primary').addClass('btn-outline-primary');
            $(this).removeClass('btn-outline-primary').addClass('btn-primary');
            horaInput.val($(this).data('time'));
        });
    });
</script>
</body>
</html>