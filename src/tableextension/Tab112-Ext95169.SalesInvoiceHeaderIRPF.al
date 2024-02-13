/// <summary>
/// TableExtension Sales Invoice HeaderIRPF (ID 80169) extends Record Sales Invoice Header.
/// </summary>
tableextension 95169 "Sales Invoice HeaderIRPF" extends "Sales Invoice Header" //112
{
    fields
    {
        field(92000; "Código grupo retención (BE)"; Code[20])
        {
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST("Good Execution"));
            DataClassification = ToBeClassified;
            Caption = 'Código grupo retención (BE)';
        }
        field(92001; "Código grupo retención (IRPF)"; Code[20])
        {
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST(IRPF));
            DataClassification = ToBeClassified;
            Caption = 'Código grupo retención (IRPF)';
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Importe retención (BE)" WHERE("Document No." = FIELD("No.")));

            Caption = 'Importe retención (BE)';
            Editable = false;
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Importe retención (IRPF)" WHERE("Document No." = FIELD("No.")));

            Caption = 'Importe retención (IRPF)';
            Editable = false;
        }

    }
}

