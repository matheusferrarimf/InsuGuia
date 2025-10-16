import { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Alert, AlertDescription } from './ui/alert';
import { Badge } from './ui/badge';
import { Separator } from './ui/separator';
import { Calculator, AlertTriangle, CheckCircle, Info } from 'lucide-react';
import type { Patient } from '../App';

interface InsulinCalculatorProps {
  selectedPatient: Patient | null;
  onUpdatePatient: (patient: Patient) => void;
}

export function InsulinCalculator({ selectedPatient, onUpdatePatient }: InsulinCalculatorProps) {
  const [currentGlycemia, setCurrentGlycemia] = useState('');
  const [mealType, setMealType] = useState<'fasting' | 'preprandial' | 'postprandial' | 'bedtime'>('preprandial');
  const [calculatedDose, setCalculatedDose] = useState<number | null>(null);
  const [recommendation, setRecommendation] = useState<string>('');

  useEffect(() => {
    if (selectedPatient?.lastGlycemia) {
      setCurrentGlycemia(selectedPatient.lastGlycemia.toString());
    }
  }, [selectedPatient]);

  const calculateCorrectionDose = () => {
    if (!selectedPatient || !currentGlycemia) return;

    const glycemia = parseFloat(currentGlycemia);
    const correctionFactor = selectedPatient.correctionFactor || 50;
    const targetMid = (selectedPatient.target.min + selectedPatient.target.max) / 2;

    // Dose de correção = (Glicemia atual - Glicemia alvo) / Fator de correção
    const dose = Math.max(0, Math.round((glycemia - targetMid) / correctionFactor));
    
    setCalculatedDose(dose);

    // Gerar recomendações
    let rec = '';
    if (glycemia < 70) {
      rec = 'ATENÇÃO: Hipoglicemia detectada. Administrar 15g de carboidratos de ação rápida. Não administrar insulina. Reavaliar glicemia em 15 minutos.';
    } else if (glycemia >= 70 && glycemia < selectedPatient.target.min) {
      rec = 'Glicemia abaixo do alvo. Considere reduzir dose de insulina basal ou ajustar meta glicêmica. Não administrar dose de correção neste momento.';
    } else if (glycemia >= selectedPatient.target.min && glycemia <= selectedPatient.target.max) {
      rec = 'Glicemia dentro do alvo terapêutico. Manter esquema atual. Dose de correção não necessária.';
    } else if (glycemia > selectedPatient.target.max && glycemia <= 180) {
      rec = `Glicemia levemente elevada. Dose de correção sugerida: ${dose} UI de insulina regular ou ultrarrápida. Reavaliar em 2-4 horas.`;
    } else if (glycemia > 180 && glycemia <= 250) {
      rec = `Hiperglicemia moderada. Dose de correção sugerida: ${dose} UI de insulina regular ou ultrarrápida. Reavaliar em 2-4 horas. Considere ajustar insulina basal se hiperglicemia persistente.`;
    } else {
      rec = `ATENÇÃO: Hiperglicemia importante. Dose de correção sugerida: ${dose} UI de insulina regular ou ultrarrápida. Investigar causas (infecção, estresse, aderência). Reavaliar em 2 horas. Considere protocolo de hiperglicemia grave se persistir.`;
    }

    setRecommendation(rec);
  };

  const calculateBasalDose = () => {
    if (!selectedPatient) return;

    // Dose inicial de insulina basal: 0.2-0.3 U/kg/dia para pacientes não críticos
    const basalDose = Math.round(selectedPatient.weight * 0.25);
    
    return basalDose;
  };

  const saveGlycemia = () => {
    if (!selectedPatient || !currentGlycemia) return;

    const updatedPatient = {
      ...selectedPatient,
      lastGlycemia: parseFloat(currentGlycemia),
      lastUpdate: new Date().toISOString(),
    };

    onUpdatePatient(updatedPatient);
  };

  if (!selectedPatient) {
    return (
      <Card>
        <CardContent className="flex flex-col items-center justify-center py-12">
          <Calculator className="w-12 h-12 text-gray-400 mb-4" />
          <p className="text-gray-500 text-center">
            Selecione um paciente na aba "Pacientes"
            <br />
            para calcular doses de insulina.
          </p>
        </CardContent>
      </Card>
    );
  }

  const glycemiaValue = parseFloat(currentGlycemia);
  const isHypoglycemia = glycemiaValue < 70;
  const isHyperglycemia = glycemiaValue > 180;

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      {/* Calculadora de Dose de Correção */}
      <Card>
        <CardHeader>
          <CardTitle>Dose de Correção</CardTitle>
          <CardDescription>
            Calcule a dose de insulina de correção baseada na glicemia atual
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="bg-indigo-50 p-4 rounded-lg space-y-2">
            <p className="text-sm">Paciente selecionado:</p>
            <p className="text-indigo-900">{selectedPatient.name}</p>
            <div className="flex gap-2 text-sm text-gray-600">
              <span>{selectedPatient.age} anos</span>
              <span>•</span>
              <span>{selectedPatient.weight} kg</span>
            </div>
          </div>

          <div className="grid gap-4">
            <div className="grid gap-2">
              <Label htmlFor="glycemia">Glicemia Atual (mg/dL)</Label>
              <Input
                id="glycemia"
                type="number"
                value={currentGlycemia}
                onChange={(e) => setCurrentGlycemia(e.target.value)}
                placeholder="Ex: 180"
              />
            </div>

            <div className="grid gap-2">
              <Label htmlFor="mealType">Momento</Label>
              <Select value={mealType} onValueChange={(value: any) => setMealType(value)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="fasting">Jejum</SelectItem>
                  <SelectItem value="preprandial">Pré-prandial</SelectItem>
                  <SelectItem value="postprandial">Pós-prandial</SelectItem>
                  <SelectItem value="bedtime">Antes de dormir</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="grid gap-2">
              <Label>Meta Glicêmica</Label>
              <div className="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                <span className="text-sm">{selectedPatient.target.min} - {selectedPatient.target.max} mg/dL</span>
              </div>
            </div>

            <div className="grid gap-2">
              <Label>Fator de Correção</Label>
              <div className="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                <span className="text-sm">{selectedPatient.correctionFactor || 50} mg/dL/UI</span>
              </div>
            </div>
          </div>

          <Separator />

          <div className="flex gap-2">
            <Button
              onClick={calculateCorrectionDose}
              disabled={!currentGlycemia}
              className="flex-1"
            >
              <Calculator className="w-4 h-4 mr-2" />
              Calcular Dose
            </Button>
            <Button
              variant="outline"
              onClick={saveGlycemia}
              disabled={!currentGlycemia}
            >
              Salvar Glicemia
            </Button>
          </div>

          {calculatedDose !== null && (
            <>
              <Separator />
              <div className={`p-4 rounded-lg ${
                isHypoglycemia ? 'bg-red-50 border border-red-200' :
                isHyperglycemia ? 'bg-yellow-50 border border-yellow-200' :
                'bg-green-50 border border-green-200'
              }`}>
                <div className="flex items-center gap-2 mb-2">
                  {isHypoglycemia || isHyperglycemia ? (
                    <AlertTriangle className="w-5 h-5 text-red-600" />
                  ) : (
                    <CheckCircle className="w-5 h-5 text-green-600" />
                  )}
                  <span className={
                    isHypoglycemia ? 'text-red-900' :
                    isHyperglycemia ? 'text-yellow-900' :
                    'text-green-900'
                  }>
                    Dose Calculada: {calculatedDose} UI
                  </span>
                </div>
                <p className="text-sm text-gray-700 mt-2">{recommendation}</p>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      {/* Esquema de Insulina e Ajustes */}
      <div className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>Esquema Atual</CardTitle>
            <CardDescription>
              Esquema de insulinoterapia do paciente
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <span className="text-sm">Tipo de Esquema:</span>
              <Badge variant="outline">
                {selectedPatient.insulinType === 'basal-bolus' ? 'Basal-Bolus' :
                 selectedPatient.insulinType === 'correction-only' ? 'Apenas Correção' :
                 'Pré-misturada'}
              </Badge>
            </div>

            {selectedPatient.insulinType === 'basal-bolus' && (
              <div className="space-y-2">
                <div className="flex items-center justify-between p-3 bg-indigo-50 rounded-lg">
                  <span className="text-sm">Dose Basal:</span>
                  <span>{selectedPatient.basalDose || calculateBasalDose()} UI/dia</span>
                </div>
                <p className="text-xs text-gray-500">
                  Insulina NPH ou análogo de longa ação (glargina, detemir, degludeca)
                </p>
              </div>
            )}

            <Alert>
              <Info className="h-4 w-4" />
              <AlertDescription className="text-sm">
                <strong>Ajustes de dose:</strong> Aumentar ou reduzir 10-20% da dose total se glicemia persistentemente fora do alvo. Reavaliar a cada 2-3 dias.
              </AlertDescription>
            </Alert>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Protocolo SBD 2025</CardTitle>
            <CardDescription>
              Diretrizes para pacientes não críticos
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="space-y-2">
              <div className="flex items-start gap-2">
                <div className="w-2 h-2 bg-indigo-600 rounded-full mt-2" />
                <div>
                  <p className="text-sm">Meta glicêmica: 100-140 mg/dL (pré-prandial)</p>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <div className="w-2 h-2 bg-indigo-600 rounded-full mt-2" />
                <div>
                  <p className="text-sm">Hipoglicemia: Tratar se &lt; 70 mg/dL</p>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <div className="w-2 h-2 bg-indigo-600 rounded-full mt-2" />
                <div>
                  <p className="text-sm">Monitorização: Capilar a cada 6h ou conforme necessário</p>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <div className="w-2 h-2 bg-indigo-600 rounded-full mt-2" />
                <div>
                  <p className="text-sm">Fator de correção: 1800/dose total diária (insulina regular) ou 1500/dose total (ultrarrápida)</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
