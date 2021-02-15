// Code By: Ashik Iqbal
// www.ashik.info

function htmlEscape(str) {
    //return str.text();
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/\\/g, '&#92;')
        ;
}

function tConfirm(confirmText) {
    jConfirm(confirmText, 'Confirmation Dialog', function (r) {
        return r;
    });
    return false;
}

function getReadableFileSizeString(fileSizeInBytes) {
    var i = -1;
    var byteUnits = [' KB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
    do {
        fileSizeInBytes = fileSizeInBytes / 1024;
        i++;
    } while (fileSizeInBytes > 1024);
    return Math.max(fileSizeInBytes, 0.1).toFixed(2) + byteUnits[i];
}

function highlight(value, term) {
    if (term.length > 0)
        return value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<span class='highlight'>$1</span>");
    return value;
}

function showLoadingDialog(titleText) {
    $("#loading").dialog({
        modal: true,
        height: 210,
        width: 240,
        resizable: false,
        draggable: false,
        title: titleText,
        closeOnEscape: false,
        disabled: true
    });
    $(".ui-dialog-titlebar-close").hide();
}

function hideLoadingDialog() {
    $("#loading").dialog("close");
    $("#loading").dialog("destroy");
}

$(document).ready(function () {
    jQueryInit();
});

function pageLoad(sender, args) {
    if (args.get_isPartialLoad()) jQueryInit();
}

//function pageLoad() {
//    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(jQueryInit);
//}


function jQueryInit() {
    $(document).ready(function () {        

        // Prevent the backspace key from navigating back.
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {

                var d = event.srcElement || event.target;
                //alert();
                if ((d.tagName.toUpperCase() === 'INPUT' && (
                    d.type.toUpperCase() === 'TEXT'
                    || d.type.toUpperCase() === 'PASSWORD'))
                    || d.tagName.toUpperCase() === 'TEXTAREA'
                    || $(d).hasClass("editable")
                    ) {
                    doPrevent = d.readOnly
                    || d.disabled;
                }
                else {
                    doPrevent = true;
                }
            }
            if (doPrevent) {
                event.preventDefault();
            }
        });
    });

    //var url = window.location;
    var url = document.location.origin + document.location.pathname;
    $('ul.nav a').filter(function () {
        return this.href == url;
    }).parents('li').addClass('active');

    $('a.blank').each(function () {
        $(this).attr("target", "_blank");
        $(this).addClass('link');
    });

    $('input:text[Watermark]').each(function () {
        $(this).watermark($(this).attr('Watermark'));
    });

    //Refresh Challenge Key
    $('#ImgChallengeReload,#ImgChallenge').click(function () {
        $('#ImgChallenge').attr('src', 'Images/loading1.gif');
        $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('').focus();
        setTimeout(function () {
            $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
        }, 100);
    });
    $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
    $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('');

    $('.search-result').each(function () {
        $(this).html(highlight($(this).html(), $('#ctl00_CpBody_txtSearch').val() ));
    });

    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })

    $("time.timeago").timeago();

    //Disable All Combo
    $("select option[value='']").attr('disabled', true);

    $('.Date').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'dd/mm/yy',
        showAnim: 'show'
    });
    $('.Date-DOB').datepicker({
        minDate: "-70Y",
        maxDate: "-18Y",
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'dd/mm/yy',
        showAnim: 'show'
    });
        
    $('.Date,.Date-DOB').watermark('dd/mm/yyyy');

    $('.loadimg').each(function () {
        var imgurl = $(this).attr('loadimg');
        $(this).attr('src', imgurl);
        $(this).attr('onerror', 'this.src=\'Images/error.png\'');
        $(this).removeAttr('loadimg');
    });
        
    //cboDegree
    var ResultHideforDegree = ["", "4", "5", "6"];
    $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboDegree").change(function () {
        if ($.inArray($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboDegree').val(), ResultHideforDegree) == -1) {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', false);
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').val('');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
        }
    });

    if ($.inArray($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboDegree').val(), ResultHideforDegree) == -1) {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', false);
    }
    else {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
    }

    //cboDegree for Professional Qualification

    $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboDegree").change(function () {
        if ($.inArray($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboDegree').val(), ResultHideforDegree) == -1) {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').val('');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
        }
    });

    if ($.inArray($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboDegree').val(), ResultHideforDegree) == -1) {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
    }
    else {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtBoard').prop('disabled', true);
    }


    //cboSubject
    $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboSubject').change(function () {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').val($(this).val());
        if ($(this).val() == "Others") {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').removeClass('hidden');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').val('');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').focus();
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').addClass('hidden');
        }
    });

    $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboSubject").val($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').val());
    if ($("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboSubject").val() == ""
        && $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboSubject").attr('tag') == "EDIT") {
        $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboSubject").val("Others");
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtSubject').removeClass('hidden');
    }

   

    //cboInstitute
    $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboInstitute').change(function () {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').val($(this).val());
        if ($(this).val() == "Others") {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').removeClass('hidden');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').val('');
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').focus();
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').addClass('hidden');
        }
    });


    $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboInstitute").val($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').val());
    if ($("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboInstitute").val() == ""
        && $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboInstitute").attr('tag') == "EDIT") {
        $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboInstitute").val("Others");
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtInstitute').removeClass('hidden');
    }


    //cboInstitute for Pro Q
    $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboInstitute').change(function () {
        $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').val($(this).val());
        if ($(this).val() == "Others") {
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').removeClass('hidden');
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').val('');
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').focus();
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').addClass('hidden');
        }
    });


    $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboInstitute").val($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').val());
    if ($("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboInstitute").val() == ""
        && $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboInstitute").attr('tag') == "EDIT") {
        $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboInstitute").val("Others");
        $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtInstitute').removeClass('hidden');
    }


    //cboResult
    var ResultHideforTextbox = ["", "Appeared", "Enrolled", "Awarded", "Do not mention"];
    if ($.inArray($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboResult').val(), ResultHideforTextbox) == -1) {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtResult').removeClass('hidden')
        $("#lblResult").removeClass('hidden');
        if ($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboResult').val() == "Grade") {
            $("#lblResult").html("CGPA:");
            $("#lblTotalCGPA").removeClass('hidden');
        }
        else {
            $("#lblResult").html("Marks:");
            $("#lblTotalCGPA").addClass('hidden');
            $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtTotalCGPA").val('');
        }
    }

    $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboResult').change(function () {
        $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtResult').val($(this).val());
        if ($.inArray($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboResult').val(), ResultHideforTextbox) == -1) {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtResult').removeClass('hidden')
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtResult').val("");
            $("#lblResult").removeClass('hidden');
            if ($('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_cboResult').val() == "Grade") {
                $("#lblResult").html("CGPA:");
                $("#lblTotalCGPA").removeClass('hidden');
            }
            else {
                $("#lblResult").html("Marks:");
                $("#lblTotalCGPA").addClass('hidden');
                $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtTotalCGPA").val('');
            }
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtResult').addClass('hidden');
            $("#lblResult").addClass('hidden');
            $("#lblTotalCGPA").addClass('hidden');
            $("#ctl00_CpBody_TabContainer1_tabEducation_DetailsViewEducation_txtTotalCGPA").val('');
        }
    });


    //cboResult for Pro Q
    var ResultHideforTextbox = ["", "Appeared", "Enrolled", "Awarded", "Do not mention"];
    if ($.inArray($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboResult').val(), ResultHideforTextbox) == -1) {
        $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtResult').removeClass('hidden')
        $("#lblResult").removeClass('hidden');
        if ($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboResult').val() == "Grade") {
            $("#lblResult").html("CGPA:");
            $("#lblTotalCGPA").removeClass('hidden');
        }
        else {
            $("#lblResult").html("Marks:");
            $("#lblTotalCGPA").addClass('hidden');
            $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtTotalCGPA").val('');
        }
    }

    $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboResult').change(function () {
        $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtResult').val($(this).val());
        if ($.inArray($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboResult').val(), ResultHideforTextbox) == -1) {
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtResult').removeClass('hidden')
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtResult').val("");
            $("#lblResult").removeClass('hidden');
            if ($('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_cboResult').val() == "Grade") {
                $("#lblResult").html("CGPA:");
                $("#lblTotalCGPA").removeClass('hidden');
            }
            else {
                $("#lblResult").html("Marks:");
                $("#lblTotalCGPA").addClass('hidden');
                $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtTotalCGPA").val('');
            }
        }
        else {
            $('#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtResult').addClass('hidden');
            $("#lblResult").addClass('hidden');
            $("#lblTotalCGPA").addClass('hidden');
            $("#ctl00_CpBody_TabContainer1_tabProfessionalQualification_DetailsViewProfessionalQualification_txtTotalCGPA").val('');
        }
    });




    //Till Date
    $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_chkTilNow').change(function () {
        if ($(this).is(':checked')) {
            $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_txtToDateExp').val('');
            $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_txtToDateExp').attr("disabled", "disabled"); 
        }
        else
            $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_txtToDateExp').removeAttr("disabled");
    });
    if ($('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_txtToDateExp').val() == '') {
        $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_txtToDateExp').prop("disabled", true);
        $('#ctl00_CpBody_TabContainer1_tabExperience_DetailsViewExperience_chkTilNow').prop('checked', true);
    }

    $('#ctl00_CpBody_TabContainer1_tabpanelPic_imgCrop').Jcrop({
        onSelect: storeCoords,
        allowSelect: false,
        setSelect: [400, 400, 0, 0],
        bgOpacity: .3,

        aspectRatio: 1,
        keySupport: false,
        minSize: [50, 50],
        boxHeight: 400
    });
        
    //Datepicker Today Problem Resolve
    $.datepicker._gotoToday = function(id) {
        var target = $(id);
        var inst = this._getInst(target[0]);
        if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
            inst.selectedDay = inst.currentDay;
            inst.drawMonth = inst.selectedMonth = inst.currentMonth;
            inst.drawYear = inst.selectedYear = inst.currentYear;
        }
        else {
            var date = new Date();
            inst.selectedDay = date.getDate();
            inst.drawMonth = inst.selectedMonth = date.getMonth();
            inst.drawYear = inst.selectedYear = date.getFullYear();
            this._setDateDatepicker(target, date);
            this._selectDate(id, this._getDateDatepicker(target));
        }
        this._notifyChange(inst);
        this._adjustDate(target);
        //this.removeClass('ui-priority-secondary');
    }

    $('[clientid=jobcategory]').multipleSelect({
        placeholder: 'please select',
        filter: false,
        selectAll: false
    });

    //--------------------------------------------------------------

        //$('.ui-datepicker-current').live('click', function() {
        //    var associatedInputSelector = $(this).attr('onclick').replace(/^.*'(#[^']+)'.*/gi, '$1');
        //    var $associatedInput = $(associatedInputSelector).datepicker("setDate", new Date());
        //    $associatedInput.datepicker("hide");
        //});
}