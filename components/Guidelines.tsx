import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from './ui/accordion';
import { Alert, AlertDescription } from './ui/alert';
import { Badge } from './ui/badge';
import { FileText, Info } from 'lucide-react';

export function Guidelines() {
  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <FileText className="w-5 h-5 text-indigo-600" />
            <CardTitle>Diretrizes SBD 2025</CardTitle>
          </div>
          <CardDescription>
            Protocolo de Insulinoterapia para Pacientes Não Críticos Hospitalizados
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Alert>
            <Info className="h-4 w-4" />
            <AlertDescription>
              Este protocolo é baseado nas diretrizes da Sociedade Brasileira de Diabetes (2025) 
              e destina-se exclusivamente a pacientes não críticos internados em enfermarias.
            </AlertDescription>
          </Alert>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Tópicos das Diretrizes</CardTitle>
        </CardHeader>
        <CardContent>
          <Accordion type="single" collapsible className="w-full">
            <AccordionItem value="item-1">
              <AccordionTrigger>1. Metas Glicêmicas</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="space-y-2">
                  <p>Para a maioria dos pacientes não críticos hospitalizados:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4">
                    <li>Glicemia pré-prandial: <Badge variant="outline">100-140 mg/dL</Badge></li>
                    <li>Glicemia aleatória: <Badge variant="outline">&lt; 180 mg/dL</Badge></li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p className="text-sm">Metas mais liberais podem ser consideradas em:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm text-gray-600">
                    <li>Pacientes com múltiplas comorbidades</li>
                    <li>Idosos com risco de hipoglicemia</li>
                    <li>Pacientes em cuidados paliativos</li>
                    <li>Pacientes com hipoglicemia assintomática</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-2">
              <AccordionTrigger>2. Esquemas de Insulinoterapia</AccordionTrigger>
              <AccordionContent className="space-y-4">
                <div className="space-y-2">
                  <p>Esquema Basal-Bolus (Preferencial):</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li><strong>Insulina Basal:</strong> NPH 2x/dia ou análogo de longa ação 1x/dia</li>
                    <li><strong>Insulina Prandial:</strong> Regular ou análogo ultrarrápido antes das refeições</li>
                    <li><strong>Insulina de Correção:</strong> Regular ou ultrarrápida conforme protocolo</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Esquema Apenas Correção:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Não recomendado como esquema único</li>
                    <li>Pode ser usado temporariamente em pacientes com hiperglicemia leve</li>
                    <li>Controle inadequado em 70% dos casos</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Dose Inicial Total:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Pacientes sem uso prévio: 0.2-0.3 U/kg/dia</li>
                    <li>Pacientes já em uso: manter dose ambulatorial + ajustes</li>
                    <li>50% como basal, 50% dividido nas refeições</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-3">
              <AccordionTrigger>3. Cálculo da Dose de Correção</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="space-y-2">
                  <p>Fator de Correção (Sensibilidade à Insulina):</p>
                  <div className="bg-indigo-50 p-4 rounded-lg space-y-2">
                    <p className="text-sm"><strong>Insulina Regular:</strong></p>
                    <p className="text-sm ml-4">FC = 1800 / Dose Total Diária</p>
                    <p className="text-sm"><strong>Insulina Ultrarrápida:</strong></p>
                    <p className="text-sm ml-4">FC = 1500 / Dose Total Diária</p>
                  </div>
                </div>
                <div className="space-y-2">
                  <p>Dose de Correção:</p>
                  <div className="bg-indigo-50 p-4 rounded-lg">
                    <p className="text-sm">Dose = (Glicemia Atual - Meta) / Fator de Correção</p>
                  </div>
                </div>
                <p className="text-sm text-gray-600">
                  Exemplo: Paciente com dose total de 40 UI/dia, glicemia de 220 mg/dL, meta de 120 mg/dL:
                  FC = 1800/40 = 45. Dose = (220-120)/45 = 2.2 UI ≈ 2 UI
                </p>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-4">
              <AccordionTrigger>4. Monitorização Glicêmica</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="space-y-2">
                  <p>Frequência recomendada:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Mínimo 4x/dia: antes das refeições e ao deitar</li>
                    <li>Adicionar medidas se sintomas de hipo/hiperglicemia</li>
                    <li>2-4h após mudanças no esquema de insulina</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Método:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Glicemia capilar (padrão-ouro em enfermaria)</li>
                    <li>Sensor contínuo quando disponível</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-5">
              <AccordionTrigger>5. Manejo da Hipoglicemia</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="bg-red-50 border border-red-200 p-4 rounded-lg space-y-2">
                  <p><strong>Definição:</strong> Glicemia &lt; 70 mg/dL</p>
                  <p><strong>Hipoglicemia Grave:</strong> &lt; 54 mg/dL</p>
                </div>
                <div className="space-y-2">
                  <p>Tratamento:</p>
                  <ol className="list-decimal list-inside space-y-1 ml-4 text-sm">
                    <li>Paciente consciente e capaz de deglutir:
                      <ul className="list-disc list-inside ml-4 mt-1">
                        <li>15g de carboidrato simples (3 sachês de açúcar ou 150ml suco)</li>
                        <li>Reavaliar em 15 minutos</li>
                        <li>Repetir se necessário</li>
                      </ul>
                    </li>
                    <li>Paciente inconsciente ou incapaz de deglutir:
                      <ul className="list-disc list-inside ml-4 mt-1">
                        <li>Glicose 50% EV: 20-40ml</li>
                        <li>Ou Glucagon 1mg IM/SC</li>
                      </ul>
                    </li>
                  </ol>
                </div>
                <div className="space-y-2">
                  <p>Prevenção de recorrência:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Reduzir dose de insulina em 10-20%</li>
                    <li>Reavaliar meta glicêmica</li>
                    <li>Investigar causas (jejum prolongado, redução de corticoide, etc.)</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-6">
              <AccordionTrigger>6. Ajustes de Dose</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="space-y-2">
                  <p>Quando ajustar:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Glicemia persistentemente fora do alvo por 2-3 dias</li>
                    <li>Episódios de hipoglicemia</li>
                    <li>Mudanças na dieta ou medicações</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Como ajustar:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Aumentar ou diminuir 10-20% da dose correspondente</li>
                    <li>Ajustar basal se glicemia de jejum alterada</li>
                    <li>Ajustar prandial se glicemia pré-refeição seguinte alterada</li>
                    <li>Reavaliar após 2-3 dias</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>

            <AccordionItem value="item-7">
              <AccordionTrigger>7. Situações Especiais</AccordionTrigger>
              <AccordionContent className="space-y-3">
                <div className="space-y-2">
                  <p>Paciente em jejum:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Suspender insulina prandial</li>
                    <li>Manter 80% da dose basal</li>
                    <li>Manter correção</li>
                    <li>Iniciar soro glicosado se jejum prolongado</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Uso de corticoides:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Aumentar dose total em 20-50%</li>
                    <li>Hiperglicemia predomina no período tarde/noite</li>
                    <li>Ajustar principalmente insulina prandial do almoço e jantar</li>
                  </ul>
                </div>
                <div className="space-y-2">
                  <p>Alta hospitalar:</p>
                  <ul className="list-disc list-inside space-y-1 ml-4 text-sm">
                    <li>Ajustar esquema para realidade ambulatorial</li>
                    <li>Educação do paciente sobre aplicação e monitorização</li>
                    <li>Acompanhamento em 1-2 semanas</li>
                  </ul>
                </div>
              </AccordionContent>
            </AccordionItem>
          </Accordion>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Referências</CardTitle>
        </CardHeader>
        <CardContent className="space-y-2 text-sm text-gray-600">
          <p>1. Sociedade Brasileira de Diabetes. Diretrizes da Sociedade Brasileira de Diabetes 2024-2025.</p>
          <p>2. American Diabetes Association. Standards of Medical Care in Diabetes - 2024.</p>
          <p>3. Umpierrez GE, et al. Management of Hyperglycemia in Hospitalized Patients in Non-Critical Care Setting: An Endocrine Society Clinical Practice Guideline. J Clin Endocrinol Metab. 2012.</p>
        </CardContent>
      </Card>
    </div>
  );
}
