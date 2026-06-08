# Erratum

**Trabajo asociado:** *Datos que transforman: lo que los datos abiertos revelan sobre cómo el BCIE convierte financiamiento en desarrollo*
**Autora:** Larissa Acosta Salgado
**Versión original:** 2 de marzo de 2026
**DOI:** [https://doi.org/10.5281/zenodo.18829251](https://doi.org/10.5281/zenodo.18829251)
**Repositorio:** [https://github.com/larissahn/BCIE](https://github.com/larissahn/BCIE)
**Fecha de la nota:** junio de 2026

---

## Resumen

Esta nota documenta un hallazgo detectado al revisar la figura del caso del Programa de Desarrollo Eléctrico ICE (Costa Rica, sección 2.1 del artículo). El hallazgo no altera los tres patrones centrales del trabajo ni ninguna de sus conclusiones; se publica por transparencia metodológica y porque su discusión enriquece el argumento sobre calibración de metas que el propio paper desarrolla.

---

## 1. Naturaleza del error

En el dataset *Operaciones_Indicadores_Producto_Efecto* descargado de la Plataforma de Datos Abiertos del BCIE (febrero de 2026), el indicador *Beneficiarias Mujeres %* asociado al Programa de Desarrollo Eléctrico ICE registra una meta ex ante de **538.7** y un último valor observado de **0.49**. La meta es manifiestamente incompatible con la naturaleza del indicador: un porcentaje no puede superar la unidad en su expresión decimal ni 100 en su expresión porcentual. El dato corresponde, casi con seguridad, a un error de captura en la carga original (algo común en datasets de este tamaño).

Existe una coincidencia numérica que sugiere un vínculo con otro campo del mismo proyecto: 502,260 dividido entre 934 da 537.75, donde 502,260 es la meta absoluta de *Beneficiarias mujeres* y 934 es la meta de *BENEFICIARIOS*, que el propio paper ya identifica como outlier (observado 1,322,263; cumplimiento 1,415 veces la meta). Una hipótesis plausible, aunque no verificada, es que el error original esté en la captura de la meta de *BENEFICIARIOS* y que el porcentaje haya heredado la inconsistencia; identificar cuál de los dos campos arrastra al otro requiere verificación con la fuente, y no puede establecerse por inferencia interna a los datos.

Cualquier intento de corregir el dato (reconstruir la meta a partir del indicador relacionado, usar la línea base como ancla, o formular una regla general de inconsistencias) introduce supuestos que el periodismo de datos no debe asumir; el deber primario es reportar lo que la fuente publica y declarar la limitación. A título informativo, si se aplicara una regla simétrica que tratara este cumplimiento implosivo como outlier, la mediana ajustada del ICE pasaría de 75% a 87.6% y el proyecto conservaría su quinta posición en la Figura 8, sin alterar ninguno de los tres patrones del trabajo.

## 2. Cómo encaja este hallazgo en el argumento del paper

El error de captura, paradójicamente, refuerza la tesis central del trabajo. El paper identifica dos tipos de problema en la calibración de metas, ambos expansivos: metas subdimensionadas que producen sobrecumplimientos artificiales (caso *BENEFICIARIOS* en ICE, asociaciones financiadas en Mercado Chorotega). Existen también cumplimientos implosivos legítimos en el propio análisis (empleos fijos en Mercado Chorotega, 12%; empleos fijos y temporales en Vacunas Honduras, 1.8%), donde la meta es estructuralmente plausible y el bajo cumplimiento refleja desempeño real, no error de captura. Este indicador agrega un subtipo distinto: cumplimiento implosivo por meta estructuralmente imposible, donde el subcumplimiento es artefacto, no desempeño. Los tres apuntan al mismo fenómeno institucional: la ausencia de validación cruzada entre meta y observado antes de la publicación del dato.

Conviene subrayar que el error solo es detectable porque el proyecto ICE reporta nueve indicadores válidos. En un proyecto con cuatro indicadores, una inconsistencia análoga quedaría enterrada por el cumplimiento promedio y nadie la notaría. El monitoreo denso no penaliza al proyecto: lo expone, lo audita, y permite que un análisis externo identifique problemas que el monitoreo escaso esconde. La validación cruzada automatizada de los datos publicados (porcentajes con meta superior a 100, por ejemplo, marcados como alerta) es un espacio concreto de mejora institucional que esta nota deja abierto y al que la propia plataforma de datos abiertos del BCIE puede dar respuesta en sus próximas iteraciones.

---

*Larissa Acosta Salgado — Tegucigalpa, junio de 2026*
