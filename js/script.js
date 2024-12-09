// Agregar registro
function addRecord() {
    var name = $("#name").val();
    var owner = $("#owner").val();
    var species = $("#species").val();
    var sex = $("#sex").val();
    var birth = $("#birth").val();
    var death = $("#death").val();

    $.post("../cgi-bin/agregar_registro.pl", {
        name: name,
        owner: owner,
        species: species,
        sex: sex,
        birth: birth,
        death: death
    }, function () {
        $("#add_new_pet_modal").modal("hide");
        readRecords();
    }).fail(function () {
        alert("Error al agregar el registro.");
    });
}

// Leer registros
function readRecords() {
    $.get("../cgi-bin/leer_registros.pl", {}, function (data) {
        $("#records_content").html(data);
    }).fail(function () {
        alert("Error al cargar los registros.");
    });
}

// Eliminar registro
function deleteRecord(id) {
    if (confirm("¿Está seguro de eliminar el registro?")) {
        $.post("../cgi-bin/eliminar_registro.pl", { id: id }, function () {
            readRecords();
        }).fail(function () {
            alert("Error al eliminar el registro.");
        });
    }
}

// Inicializar
$(document).ready(function () {
    readRecords();
});
