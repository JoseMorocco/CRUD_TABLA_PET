#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/html; charset=utf-8');

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, PrintError => 0 })
    or die "No se pudo conectar: $DBI::errstr";

# Consultar los registros de la tabla 'pet'
my $sth = $dbh->prepare("SELECT id, name, owner, species, sex, birth, death FROM pet")
    or die "Error al preparar la consulta: $DBI::errstr";

$sth->execute()
    or die "Error al ejecutar la consulta: $DBI::errstr";

# Generar HTML de la tabla
print <<'HTML';
<table class="table table-bordered table-striped">
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
HTML

my $count = 1;
while (my $row = $sth->fetchrow_hashref) {
    print "<tr>
        <td>$count</td>
        <td>$row->{name}</td>
        <td>$row->{owner}</td>
        <td>$row->{species}</td>
        <td>$row->{sex}</td>
        <td>$row->{birth}</td>
        <td>$row->{death}</td>
        <td>
            <button onclick=\"deleteRecord($row->{id})\" class=\"btn btn-danger\">Eliminar</button>
        </td>
    </tr>";
    $count++;
}

print '</table>';
$dbh->disconnect;
