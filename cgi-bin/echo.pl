#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;
use JSON;
use utf8;

# Crear el objeto CGI
my $q = CGI->new;

# Configurar la cabecera para devolver tanto el JSON como el HTML
print $q->header('text/html; charset=utf-8');

# Conectar a la base de datos
my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678')
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Preparar la consulta SQL
my $sth = $dbh->prepare("SELECT name, owner, species, sex, birth, death FROM pet")
    or die "Error al preparar la consulta: $DBI::errstr";

$sth->execute()
    or die "Error al ejecutar la consulta: $DBI::errstr";

# Crear el objeto para los datos
my %pets;
my ($name, $owner, $species, $sex, $birth, $death);
my $i = 0;

# Recopilar los datos de la base de datos
while (($name, $owner, $species, $sex, $birth, $death) = $sth->fetchrow()) {
    $i++;
    $pets{$i} = {
        name    => $name,
        owner   => $owner,
        species => $species,
        sex     => $sex,
        birth   => $birth,
        death   => $death,
    };
}

# Convertir los datos en JSON
my $json_pets = encode_json(\%pets);

# Imprimir los datos JSON para depuración
print "<script>console.log('Datos JSON desde la base de datos: ', $json_pets);</script>";



print <<'HTML';
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>CRUD con Perl y MySQL</title>

<!-- Bootstrap core CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
<!-- Iconos -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">

</head>
<body>

<div class="container">
  <h3 class="mt-5">CRUD con Perl y MySQL - Tabla Pet</h3>
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
    <thead>
        <tr>
            <th>No.</th>
            <th>Nombre</th>
            <th>Dueño</th>
            <th>Especie</th>
            <th>Sexo</th>
            <th>Fecha de Nacimiento</th>
            <th>Fecha de Defunción</th>
            <th>Acciones</th>
        </tr>
    </thead>
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
        <form method="POST" action="agregar_registro.pl">
          <div class="form-group">
            <label for="name">Nombre de la Mascota</label>
            <input type="text" id="name" name="name" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="owner">Dueño</label>
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
            <label for="death">Fecha de Defunción</label>
            <input type="date" id="death" name="death" class="form-control">
          </div>
             <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary">Agregar</button>
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
        <div class="form-group">
          <label for="update_name">Nombre de la Mascota</label>
          <input type="text" id="update_name" class="form-control">
        </div>
        <div class="form-group">
          <label for="update_owner">Dueño</label>
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
          <label for="update_death">Fecha de Defunción</label>
          <input type="date" id="update_death" class="form-control">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary" onclick="leer_detalles_registro()">Guardar Cambios</button>
      </div>
    </div>
  </div>
</div>

<!-- JS dependencias -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/jquery-1.11.3.min.js"></script> 
<script src="../js/script.js"></script>


</body>
</html>

HTML

