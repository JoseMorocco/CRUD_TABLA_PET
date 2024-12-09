#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;
use JSON;
use utf8;

my $q = CGI->new;

print $q->header('text/html; charset=utf-8');

my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678')
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

print <<'HTML';
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>CRUD en la Tabla PET usando AJAX</title>

<!-- Bootstrap core CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

<div class="container">
  <h3 class="mt-5">CRUD en la Tabla PET usando AJAX</h3>
  <hr>
  
  <!-- Botón para agregar una nueva mascota -->
  <div class="row mt-4">
    <div class="col-md-12 text-right">
      <button class="btn btn-success" data-toggle="modal" data-target="#add_new_pet_modal">Agregar Mascota</button>
    </div>
  </div>
  <br>
  
  <!-- Contenido principal dinámico -->
  <div class="row">
    <div class="col-md-12">
      <div id="records_content">Aquí se cargarán los registros</div>

      <table class="table table-bordered table-striped">
        <tbody id="table-body">
            <!-- Las filas dinámicas aparecerán aquí -->
        </tbody>
      </table>
    </div>
  </div>
</div>


<!-- Modal para agregar nuevo registro -->
<div class="modal fade" id="add_new_pet_modal" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Agregar Nueva Mascota</h5>
        <button class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body">
        <form id="add_pet_form">
          <div class="form-group">
            <label for="id">ID</label>
            <input type="text" id="id" name="id" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="name">Nombre de la Mascota</label>
            <input type="text" id="name" name="name" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="owner">Propietario</label>
            <input type="text" id="owner" name="owner" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="species">Especie</label>
            <input type="text" id="species" name="species" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="sex">Sexo</label>
            <select id="sex" name="sex" class="form-control" required>
              <option value="m">Masculino</option>
              <option value="f">Femenino</option>
            </select>
          </div>
          <div class="form-group">
            <label for="birth">Fecha de Nacimiento</label>
            <input type="date" id="birth" name="birth" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="death">Fecha de Fallecimiento</label>
            <input type="date" id="death" name="death" class="form-control">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
            <button type="button" class="btn btn-primary" onclick="addRecord()">Agregar</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>


<!-- Modal - Actualizar Registro Detalles-->
<div class="modal fade" id="update_pet_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Actualizar Registro</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="hidden_user_id">

        <div class="form-group">
          <label for="update_name">Nombre de la Mascota</label>
          <input type="text" id="update_name" class="form-control">
        </div>
        <div class="form-group">
          <label for="update_owner">Propietario</label>
          <input type="text" id="update_owner" class="form-control">
        </div>
        <div class="form-group">
          <label for="update_species">Especie</label>
          <input type="text" id="update_species" class="form-control">
        </div>
        <div class="form-group">
          <label for="update_sex">Sexo</label>
          <select id="update_sex" class="form-control">
            <option value="m">Masculino</option>
            <option value="f">Femenino</option>
          </select>
        </div>
        <div class="form-group">
          <label for="update_birth">Fecha de Nacimiento</label>
          <input type="date" id="update_birth" class="form-control">
        </div>
        <div class="form-group">
          <label for="update_death">Fecha de Fallecimiento</label>
          <input type="date" id="update_death" class="form-control">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary" onclick="UpdateUserDetails()">Guardar Cambios</button>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="../js/script.js"></script>

</body>
</html>
HTML


