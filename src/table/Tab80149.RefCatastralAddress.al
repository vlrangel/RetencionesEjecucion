/// <summary>
/// Table Ref Catastral Address (ID 7010462).
/// </summary>
table 80149 "Ref Catastral Address"
{

    DataCaptionFields = "Vendor No.", Name, "Code";
    Caption = 'Dirección Catastral';
    LookupPageId = 80149;
    DrillDownPageId = 80149;
    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            Caption = 'Nº proveedor';
            NotBlank = true;
        }
        field(2; "Code"; Code[30])
        {
            ValidateTableRelation = false;
            Caption = 'Código';
            NotBlank = true;
            TableRelation = if (Tipo = CONST(Proveedor)) Vendor."No."
            ELSE
            if (Tipo = CONST(Direccion)) "Order Address".Code WHERE("Vendor No." = FIELD("Vendor No."));
            trigger OnValidate()
            VAR
                Vendor: Record Vendor;
                Direcciones: Record 224;
            BEGIN
                if "Vendor No." = '' THEN BEGIN
                    "Code" := '';
                    EXIT;
                END;
                CASE Tipo OF
                    Tipo::Proveedor:
                        Vendor.GET("Code");
                    Tipo::Direccion:
                        Direcciones.GET("Vendor No.", "Code");
                END;
            END;

        }
        field(3; "Name"; Text[50])
        {
            Caption = 'Nombre';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Nombre 2';
        }
        field(5; "Address"; Text[50])
        {
            Caption = 'Dirección';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Dirección 2';
        }
        field(7; "City"; Text[30])
        {
            Caption = 'Población';
            trigger OnValidate()
            BEGIN
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", false);
            END;

            trigger OnLookup()
            BEGIN
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            END;

        }
        field(8; "Contact"; Text[50])
        {
            Caption = 'Contacto';
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Nº teléfono';
        }
        field(10; "Telex No."; Text[30])
        {
            Caption = 'Nº telex';
        }
        field(35; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Cód. país/región';
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Fecha últ. modificación';
            Editable = false;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Nº fax';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Nº telex respuesta';
        }
        field(91; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            Caption = 'C.P.';
            trigger OnValidate()
            BEGIN
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", false);
            END;

            trigger OnLookup()
            BEGIN
                PostCode.LookUpPostCode(City, "Post Code", County, "Country/Region Code");
            END;

        }
        field(92; "County"; Text[30]) { Caption = 'Provincia'; }
        field(102; "E-Mail"; Text[80]) { Caption = 'Correo electrónico'; }
        field(103; "Home Page"; Text[80]) { Caption = 'Página Web'; }
        field(104; "Ref. catastral"; Text[30]) { }
        field(105; "Situación inmueble"; Code[10]) { }
        field(106; "Tipo"; Enum "Tipo Inmueble") { }
        field(107; "Base"; Decimal) { }
        field(108; "Retención"; Decimal) { }
        field(109; "Cif"; Text[30]) { }
    }
    KEYS
    {
        key(Principal; "Vendor No.", "Code") { Clustered = true; }
    }

    VAR
        Text000: label 'ENU=untitled;ESP=SinTitulo';
        Vend: Record Vendor;

        PostCode: Record 225;

    trigger OnInsert()
    BEGIN
        Vend.GET("Vendor No.");
        Name := Vend.Name;
    END;

    trigger OnModify()
    BEGIN
        "Last Date Modified" := TODAY;
    END;

    trigger OnRename()
    BEGIN
        "Last Date Modified" := TODAY;
    END;

    PROCEDURE Caption(): Text[130];
    BEGIN
        if "Vendor No." = '' THEN
            EXIT(Text000);
        Vend.GET("Vendor No.");
        EXIT(STRSUBSTNO('%1 %2 %3 %4', Vend."No.", Vend.Name, Code, Name));
    END;

    PROCEDURE DisplayMap();
    VAR
        MapPoint: Record 800;
        MapMgt: Codeunit "Online Map Management";
    BEGIN
        if MapPoint.FIND('-') THEN
            MapMgt.MakeSelection(DATABASE::"Order Address", GETPOSITION);
    END;


}
